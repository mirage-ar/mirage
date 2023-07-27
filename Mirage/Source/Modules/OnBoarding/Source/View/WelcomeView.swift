//
//  WelcomeView.swift
//  Mirage
//
//  Created by Saad on 13/07/2023.
//

import SwiftUI
import AVKit

struct WelcomeView: View {
    let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "welcome-screen", ofType: "mp4")!))
    @State var showAuthenticationView = false
    var body: some View {
        NavigationStack {
            
            ZStack {
                AVPlayerControllerRepresented(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                    .onAppear {
                        player.play()
                    }
                GeometryReader { geometry in
                    
                    VStack(spacing: 20) {
                        Spacer()
                        Images.mirageLogo.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 124, height: 69)
                        Text("In Mirage you can create and collect geolocated AR Miras")
                            .font(.body1)
                            .lineLimit(2)
                        Spacer()
                        LargeButton(title: "GET STARTED") {
                            //Commented because it needs to be displayed on every launch
//                            UserDefaultsStorage().save(true, for: .getStartedLaunched)
                            AppConfiguration.shared.getStartedLaunched = true
                        }
                        .cornerRadius(24)
                        
                    }
                }
                .frame(maxWidth: 0.7 * UIScreen.main.bounds.width)
                
            }
        }
    }
}


struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        player.actionAtItemEnd = .none
        controller.player = player
        context.coordinator.addListner()
        controller.showsPlaybackControls = false
        return controller
        
    }
    
    
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: AVPlayerControllerRepresented
        
        init(_ parent: AVPlayerControllerRepresented) {
            self.parent = parent
        }
        func addListner() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: nil)

        }
        @objc func playerItemDidReachEnd(notification: Notification) {
            parent.player.seek(to: CMTime.zero)
        }

    }
}

