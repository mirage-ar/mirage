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
    @State var scaleLabelOpacity: Double = 0.6

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
                                .lineLimit(1)
                                .foregroundColor(Colors.g3Grey.swiftUIColor)
                                .opacity(scaleLabelOpacity)
                                .onChange(of: viewModel.hideScaleLabel) { newValue in
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        if newValue == false {
                                            scaleLabelOpacity = 0.6
                                        } else {
                                            scaleLabelOpacity = 0.0
                                        }
                                    }
                                }
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
