//
//  DownloadManager.swift
//  Mirage
//
//  Created by Saad on 27/06/2023.
//

import Foundation
import UIKit
import Alamofire

public class DownloadManager {
    static let shared = DownloadManager()
    private var fileSet: [String: File]
    private let fileSetKey = (Bundle.main.bundleIdentifier ?? "") + "_DownloadFileSet"
    private let accessToken =  "Bearer \(UserDefaultsStorage().getString(for: .accessToken) ?? "")"
    private let maxRetries = 3
    
    init() {
        AF.sessionConfiguration.timeoutIntervalForRequest = 30
        AF.sessionConfiguration.timeoutIntervalForResource = 30
        AF.sessionConfiguration.httpMaximumConnectionsPerHost = 10
        
        if let data = UserDefaults.standard.object(forKey: fileSetKey) as? Data,
           let dict = try? JSONDecoder().decode([String: File].self, from: data) {
            fileSet = dict
            
        } else {
            fileSet = Dictionary()
        }
//        processPreviousFiles()
    }
    
    func download(url: String, progressHandler: ((Progress) -> Void)?, completion: ((String?) -> ())?) {
        let queue = DispatchQueue(label: "downloadFiles", qos: .background, attributes: .concurrent)
        if let file = fileSet[url], file.status == .completed, !file.filePath.isEmpty {
            completion?(file.filePath)
            return
        }
        fileStarted(url: url, operation: .download)
        AF.request(
            url,
            method: .get,
            headers: [])
        .downloadProgress(closure: { progress in
                //progress update
                progressHandler?(progress)
        }).responseData (queue: queue) { [weak self] response in
                
                if let data = response.value, let URL = response.request?.url{
                    let fileName = URL.lastPathComponent
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileUrl = documentsURL.appendingPathComponent(fileName)
                    do {
                        try data.write(to: fileUrl)
                        self?.fileCompleted(url: url, filePath: fileUrl.absoluteString , operation: .download)
                        completion?(fileUrl.absoluteString)
                        } catch (let e){
                            debugPrint("Error Saving File:\(fileUrl) Error:\(e)")
                            completion?(nil)
                    }
                    print(fileUrl)
                }

            }

    }
    func upload(image: UIImage, completion: ((String?) -> ())?) {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileName = UUID().uuidString + ".jpg"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentsURL.appendingPathComponent(fileName)
        do {
            try data?.write(to: fileUrl)
                upload(filePath: fileUrl.absoluteString, completion: completion)
            } catch (let e){
                debugPrint("Error Saving File:\(fileUrl) Error:\(e)")
                completion?(nil)
        }

    }
    func upload(filePath: String, completion: ((String?) -> ())?) {
        if let file = fileSet[filePath], file.status == .completed, !file.filePath.isEmpty {
            //this is just to return url. to display. please use local file path to display
            completion?(file.filePath)
            return
        }
        
        guard let fileUrl = URL(string: filePath) else { return }
        let queue = DispatchQueue(label: "downloadFiles", qos: .background, attributes: .concurrent)

        let headers: HTTPHeaders = ["content-type": "multipart/form-data; boundary=---011000010111000001101001", "authorization": accessToken]
        fileStarted(url: filePath, operation: .upload)

        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileUrl, withName: fileUrl.lastPathComponent)
        }, to: "https://3dke7yk5g5hlo2nhfinpnbf3h40mauci.lambda-url.us-east-1.on.aws", method: .post, headers: headers).responseDecodable(of: [UploadResponse].self, queue: queue) { response in
            let result = response.result.map { $0.first?.url ?? "" }
            print(result)

            switch result {
            case .success(let url):
                debugPrint(url)
                self.fileCompleted(url: filePath, filePath: url, operation: .upload)
                completion?(url)
            case .failure(let encodingError):
                self.fileFailed(url: filePath)
                debugPrint(encodingError)
                completion?(nil)
            }
        }
    }
    //MARK: File Actions
    private func synchronizeFileSet() {
        let data = try? JSONEncoder().encode(fileSet)
        UserDefaults.standard.set(data, forKey: fileSetKey)
        UserDefaults.standard.synchronize()
    }
    private func fileStarted(url: String, operation: File.Operation) {
        var file = fileSet[url] //to accomodate retries
        if file == nil {
            file = File(url: url, operation: operation)
        }
        file?.status = .inProgress
        fileSet[url] = file
        synchronizeFileSet()
    }
    private func update(url: String, status: File.Status, operation: File.Operation) {
        var file = fileSet[url]
        if file == nil {
            file = File(url: url, operation: operation)
        }
        file?.status = status
        fileSet[url] = file
        synchronizeFileSet()
    }
    private func fileCompleted(url: String, filePath: String, operation: File.Operation) {
        var file = fileSet[url]
        if file == nil {
            file = File(url: url, status: .completed, operation: operation)
        }
        file?.filePath = filePath
        file?.completedAt = .now
        synchronizeFileSet()
    }
    private func fileFailed(url: String) {
        guard var file = fileSet[url] else { return }
        
        if file.retries < maxRetries {
            file.retries += 1
            file.failedAt = .now
            file.lastRetry = .now
            fileSet[url] = file
            synchronizeFileSet()
            if file.operation == .download {
                download(url: file.url, progressHandler: nil, completion: nil)
            } else {
                upload(filePath: file.filePath, completion: nil)
            }
        }
    }
    
    private func processPreviousFiles() {
        let incompleteFiles = fileSet.values.filter { $0.status != .completed }
        for var file in incompleteFiles {
            file.priority = .low
            file.status = .inProgress
            file.retries = 0
            file.failedAt = nil
            file.lastRetry = nil
            fileSet[file.url] = file
            if file.operation == .download {
                download(url: file.url) { progress in
                    debugPrint("Progress \(file.url) \(progress)")
                } completion: { filePath in
                    debugPrint("Completed \(file.url) " + (filePath ?? ""))
                }

                download(url: file.url, progressHandler: nil, completion: nil)
            } else {
                
                upload(filePath: file.filePath) { url in
                    debugPrint("Completed \(file.filePath) with \(url ?? "NA")")
                }
            }
        }
        synchronizeFileSet()
    }
    
}

struct UploadResponse: Decodable {
    let url: String
}

struct File {
    
    let url: String //In case of upload. url will be local filePath. in case of download. url will be server URL.
    var filePath: String = ""
    var status: Status = .notStarted
    var retries: Int = 0
    var startedAt: Date = .now
    var completedAt: Date?
    var failedAt: Date?
    var lastRetry: Date?
    var priority: Priority = .medium
    let operation: Operation
    
    enum Status: Int, Codable {
        case notStarted = 0, inProgress, failed, completed
    }
    enum Operation: Int, Codable {
        case download = 0, upload
    }
    enum Priority: Int, Codable {
        case low = 0, medium = 1, high = 2
    }
    
}
extension File: Codable {
    enum CodingKeys: String, CodingKey {
        case url
        case filePath
        case status
        case retries
        case startedAt
        case completedAt
        case failedAt
        case lastRetry
        case priority
        case operation
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
        filePath = try values.decode(String.self, forKey: .filePath)
        status = try values.decode(Status.self, forKey: .status)
        retries = try values.decode(Int.self, forKey: .retries)
        startedAt = try values.decode(Date.self, forKey: .startedAt)
        completedAt = try? values.decode(Date.self, forKey: .completedAt)
        failedAt = try? values.decode(Date.self, forKey: .failedAt)
        lastRetry = try? values.decode(Date.self, forKey: .lastRetry)
        priority = try values.decode(Priority.self, forKey: .priority)
        operation = try values.decode(Operation.self, forKey: .operation)
    }

    func encode(with encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(filePath, forKey: .filePath)
        try container.encode(status, forKey: .status)
        try container.encode(retries, forKey: .retries)
        try container.encode(startedAt, forKey: .startedAt)
        try container.encode(completedAt, forKey: .completedAt)
        try container.encode(failedAt, forKey: .failedAt)
        try container.encode(lastRetry, forKey: .lastRetry)
        try container.encode(priority, forKey: .priority)
        try container.encode(operation, forKey: .operation)
    }
}
