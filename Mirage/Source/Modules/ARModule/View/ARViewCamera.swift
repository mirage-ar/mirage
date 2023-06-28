//
//  ARCameraView.swift
//  Mirage
//
//  Created by Fiig on 10/04/2023.
//

import SwiftUI

struct ARViewCamera: View {
    @ObservedObject private var viewModel = ARViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                VStack {
                    ZStack {
                        ARViewContainer(viewModel: viewModel)
                            .cornerRadius(20)
                            .edgesIgnoringSafeArea(.top)
                    }

                    ARViewBottomBar(viewModel: viewModel)
                        .frame(height: geo.size.height * 0.05)
                }
            }
        }
    }
}
