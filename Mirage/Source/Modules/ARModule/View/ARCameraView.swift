//
//  ARCameraView.swift
//  Mirage
//
//  Created by Saad on 10/04/2023.
//

import SwiftUI

struct ARCameraView: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                VStack {
                    ZStack {
                        ARViewContainer()
                            .cornerRadius(20)
                            .edgesIgnoringSafeArea(.top)
                    }

                    BottomBar()
                        .frame(height: geo.size.height * 0.05)
                }
            }
        }
    }
}
