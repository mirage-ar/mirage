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
    init() {
        AF.sessionConfiguration.timeoutIntervalForRequest = 30
        AF.sessionConfiguration.timeoutIntervalForResource = 30
        AF.sessionConfiguration.httpMaximumConnectionsPerHost = 10
        
        if let dict = UserDefaults.standard.object(forKey: fileSetKey) as? [String: File] {
            fileSet = dict
        } else {
            fileSet = Dictionary()
        }
    }
    
    func download(url: String, progressHandler: @escaping ((Progress) -> Void), completion: @escaping ((String?) -> ())) {
        let queue = DispatchQueue(label: "downloadFiles", qos: .background, attributes: .concurrent)

        AF.request(
            url,
            method: .get,
            headers: [])
        .downloadProgress(closure: { progress in
                //progress update
                progressHandler(progress)
        }).responseData (queue: queue) { response in
                
                if let data = response.value, let url = response.request?.url{
                    let fileName = url.lastPathComponent
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileUrl = documentsURL.appendingPathComponent(fileName)
                    do {
                        try data.write(to: fileUrl)
                        completion(fileUrl.absoluteString)
                        } catch (let e){
                            print("Error Saving File:\(fileUrl) Error:\(e)")
                            completion(nil)
                    }
                    print(fileUrl)
                }

            }

    }
    
    func upload(image: UIImage, completion: @escaping ((String?) -> ())) {
        let queue = DispatchQueue(label: "downloadFiles", qos: .background, attributes: .concurrent)

        let headers: HTTPHeaders = ["content-type": "multipart/form-data; boundary=---011000010111000001101001", "authorization": accessToken]
        let imageData = image.jpegData(compressionQuality: 0.50)

        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "swift_file.png", mimeType: "image/png")
        }, to: "https://3dke7yk5g5hlo2nhfinpnbf3h40mauci.lambda-url.us-east-1.on.aws", method: .post, headers: headers).responseDecodable(of: [UploadResponse].self, queue: queue) { response in
            let result = response.result.map { $0.first?.url ?? "" }
            print(result)

            switch result {
            case .success(let url):
                print(url)
                completion(url)
            case .failure(let encodingError):
                print(encodingError)
                completion(nil)
            }
        }
    }
    
}

struct UploadResponse: Decodable {
    let url: String
}

struct File {
    
    let url: String
    let filePath: String = ""
    let status: Status = .notStarted
    let retries: Int = 0
    let startedAt: Date = .now
    let completedAt: Date
    let failedAt: Date
    
    enum Status: Int {
        case notStarted = 0, inProgress, failed
    }
}
