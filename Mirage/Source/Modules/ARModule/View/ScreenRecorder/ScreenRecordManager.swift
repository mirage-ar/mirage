//
//  ScreenRecordManager.swift
//  Mirage
//
//  Created by Saad on 22/08/2023.
//

import ReplayKit

class ScreenRecordManager: ObservableObject {
    
    static let shared = ScreenRecordManager()
    @Published var isRecording = false
    let recorder = RPScreenRecorder.shared()
    func startRecord() {
       guard recorder.isAvailable else {
           debugPrint("Recording is not available at this time.")
           return
       }
       if !recorder.isRecording {
           recorder.startRecording { (error) in
               guard error == nil else {
                   debugPrint("There was an error starting the recording.")
                   return
               }
               debugPrint("Started Recording Successfully")
               self.isRecording = true
           }
       }
   }
   
    func stopRecord(completion: @escaping (RPPreviewViewController) -> Void) {
       recorder.stopRecording { (preview, error) in
           debugPrint("Stopped recording")
           self.isRecording = false

           guard let preview = preview else {
               debugPrint("Preview controller is not available.")
               return
           }
           completion(preview)
//           self.previewView = RecordingPreviewView(rpPreviewViewController: preview, isShow: self.$isShowPreviewVideo)
//           withAnimation {
//               self.isShowPreviewVideo = true
//           }
       }
   }

}
