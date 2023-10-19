//
//  ARCameraView.swift
//  Mirage
//
//  Created by Fiig on 10/04/2023.
//

import SwiftUI
import ARKit

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
                        
                        // removing for now so media picker shows correctly
//                            .edgesIgnoringSafeArea(.top)
                        VStack{
                            Spacer()
                            Text(viewModel.scaleText)
                                .font(.bigScreen)
                                .foregroundColor(.white)
                                .hiddenConditionally(isHidden: viewModel.hideScaleLabel)
                        }
                        .padding(.bottom, 100)
                        
                    }

                    ARViewBottomBar(viewModel: viewModel)
                        .frame(height: geo.size.height * 0.05)
                }
            }
        }
    }
}
