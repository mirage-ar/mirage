//
//  BottomBar.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct ARViewBottomBar: View {
    @StateObject var viewModel: ARViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.bottom)

                HStack(spacing: 0) {
                    // LEFT BUTTON
                    HStack {
                        if viewModel.miraCreateMenuType != .DEFAULT {
                            Button {
                                if viewModel.miraCreateMenuType == .MODIFY {
                                    viewModel.sceneData.selectedModifier = viewModel.sceneData.previousModifier
                                    viewModel.removeModifier(.rotate)
                                }
                                    
                                if viewModel.miraCreateMenuType == .SHAPE {
                                    viewModel.sceneData.selectedShape = viewModel.sceneData.previousShape
                                    viewModel.revertShape()
                                }
                                    
                                viewModel.miraCreateMenuType = .DEFAULT
                                    
                            } label: {
                                Images.buttonClose.swiftUIImage
                            }
                        } else if viewModel.currentMira != nil && viewModel.sceneData.selectedEntity == nil {
                            Button {
                                print("UPDATE: Cancel current Mira create")
                                viewModel.currentMira = nil
                                viewModel.sceneData.removeAllMedia()
                            } label: {
                                Text("CANCEL")
                                    .foregroundColor(.white)
                                    .font(.body1)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width / 3)

                    // Middle Section
                    HStack {
                        if viewModel.miraCreateMenuType == .MODIFY {
                            ARViewModifierMenu(viewModel: viewModel)
                        } else if viewModel.miraCreateMenuType == .SHAPE {
                            Text("SHAPE")
                                .foregroundColor(.white)
                                .font(.body1)
                        } else {
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 3)

                    // Right Section
                    HStack {
                        Spacer()
                        if viewModel.miraCreateMenuType == .MODIFY || viewModel.miraCreateMenuType == .SHAPE {
                            Button {
                                if viewModel.miraCreateMenuType == .MODIFY {
                                    viewModel.sceneData.previousModifier = viewModel.sceneData.selectedModifier
                                }
                                
                                if viewModel.miraCreateMenuType == .SHAPE {
                                    viewModel.sceneData.previousShape = viewModel.sceneData.selectedShape
                                }
                                
                                viewModel.miraCreateMenuType = .DEFAULT
                                
                            } label: {
                                Images.buttonCheck.swiftUIImage
                            }
                        } else if viewModel.miraCreateMenuType == .DEFAULT && viewModel.sceneData.selectedEntity != nil {
                            Button {
                                viewModel.sceneData.selectedEntity = nil
                            } label: {
                                Text("DONE")
                                    .foregroundColor(.white)
                                    .font(.body1)
                            }
                            
                        } else if viewModel.currentMira == nil {
                            Button {
                                // UPDATE - close AR view -
                                viewModel.closeARSession()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Images.arrowB24.swiftUIImage
                            }
                        
                        } else {
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 3)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}
