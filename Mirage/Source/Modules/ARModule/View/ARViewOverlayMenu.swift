//
//  ARViewOverlayMenu.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import ReplayKit
import SwiftUI

// TODO: refactor to be in colummns like in bottom bar
struct ARViewOverlayMenu: View {
    @EnvironmentObject var stateManager: StateManager
    @StateObject var viewModel: ARViewModel
    @State var showImage: Bool = false
    @State var previewView: RecordingPreviewView?
    @State var isShowPreviewVideo = false
    
    @State var isScreenRecording: Bool = false
    
    let generator = UIImpactFeedbackGenerator(style: .medium)

    // TODO: this needs a refactor
    var body: some View {
        
        ZStack {
            if isShowPreviewVideo {
                previewView
                    .transition(.move(edge: .bottom))
                    .edgesIgnoringSafeArea(.all)
            }
            
            // mira posted notification
            VStack {
                if showImage {
                    Images.miraPosted.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .transition(.move(edge: .top)) // Image enters and exits from the top
                }
                Spacer()
            }
            .padding(.top, -10)
            
            VStack {
                
                Spacer()
                
                Group {
                    if viewModel.arViewMode == .CREATE {
                        if viewModel.currentMira != nil && viewModel.sceneData.selectedEntity == nil && viewModel.arViewLocalized {
                            ZStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        print("UPDATE: Create Mira")
                                        viewModel.lockMira()
                                        viewModel.currentMira = nil
                                        // show animation
                                        
                                        withAnimation(.easeInOut(duration: 1)) { // Change 1 to the number of seconds you want the animation to last
                                            self.showImage = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Change 2 to the number of seconds you want the image to stay on screen before it starts to exit
                                            withAnimation(.easeInOut(duration: 1)) { // Change 1 to the number of seconds you want the exit animation to last
                                                self.showImage = false
                                            }
                                        }
                                        
                                        //                            miraPosted = true
                                        //                        viewModel.removeAllMedia()
                                        //                        viewModel.arViewMode = .EXPLORE
                                    } label: {
                                        // TODO: update to better handle state ? loading
                                        Text("Lock Mira")
                                            .foregroundColor(.black)
                                            .font(.body1)
                                            .padding()
                                            .textCase(.uppercase)
                                            .frame(maxWidth: 158)
                                            .background(Color.white)
                                            .cornerRadius(100) // Change this to modify corner roundness
                                    }
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        viewModel.triggerHapticFeedback()
                                        viewModel.sceneData.showMediaPicker = true
                                    }, label: {
                                        Images.buttonMedia.swiftUIImage
                                    })
                                    .padding(16)
                                }
                            }
                        } else if viewModel.sceneData.selectedEntity != nil {
                            switch viewModel.miraCreateMenuType {
                            case .DEFAULT:
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            haptic()
                                            viewModel.miraCreateMenuType = .MODIFY
                                        } label: {
                                            //                        Image("button-modify")
                                            Images.buttonModify.swiftUIImage
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                        }
                                        
                                        Button {
                                            haptic()
                                            viewModel.miraCreateMenuType = .SHAPE
                                        } label: {
                                            Images.buttonShape.swiftUIImage
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                        }
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Button {
                                            haptic()
                                            
                                            if let entity = viewModel.sceneData.selectedEntity?.entity {
                                                viewModel.removeEntity(entity)
                                            }
                                        } label: {
                                            Images.buttonTrash.swiftUIImage
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                        }
                                    }
                                }
                                
                            case .MODIFY:
                                HStack {
                                    Image("none") // TODO: add slider
                                }
                                
                            case .SHAPE:
                                HStack {
                                    ShapeButton(shape: .plane, enabledShape: $viewModel.sceneData.selectedShape, buttonAction: viewModel.applyShape)
                                    
                                    ShapeButton(shape: .cube, enabledShape: $viewModel.sceneData.selectedShape, buttonAction: viewModel.applyShape)
                                    
                                    ShapeButton(shape: .sphere, enabledShape: $viewModel.sceneData.selectedShape, buttonAction: viewModel.applyShape)
                                }
                            }
                        } else {
                            HStack {
                                Button(action: {
                                    isScreenRecording.toggle()
                                    if isScreenRecording {
                                        ScreenRecordManager.shared.startRecord()
                                    } else {
                                        ScreenRecordManager.shared.stopRecord { preview in
                                            self.previewView = RecordingPreviewView(rpPreviewViewController: preview, isShow: self.$isShowPreviewVideo)
                                            withAnimation {
                                                self.isShowPreviewVideo = true
                                            }
                                        }
                                        
                                    }
                                }, label: {
                                    if isScreenRecording {
                                        Images.recordingOn.swiftUIImage
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Images.recordingOff.swiftUIImage
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }
                                })
                                Spacer()
                                
                                Button(action: {
                                    viewModel.triggerHapticFeedback()
                                    viewModel.sceneData.showMediaPicker = true
                                }, label: {
                                    Images.buttonMedia.swiftUIImage
                                })
                                .padding(16)
                            }
                        }
                    } else if viewModel.selectedMira != nil {
                        ARViewSocialMenu(viewModel: viewModel, selectedUserOnMap: $stateManager.selectedUserOnMap, userId: stateManager.loggedInUser?.id)
                    }
                }
                .padding([.leading, .trailing, .bottom])
                
            }
        }
        
    }
    
    func haptic() {
        generator.prepare()
        generator.impactOccurred()
    }
}

struct ShapeButton: View {
    let shape: ShapeType
    @Binding var enabledShape: ShapeType
    
    let buttonAction: (ShapeType) -> Void
    
    var body: some View {
        Button {
            buttonAction(shape)
        } label: {
            if enabledShape == shape {
                selectedShape(shape)
            } else {
                unselectedShape(shape)
            }
//            Circle()
//                .frame(width: 48, height: 48)
//                .foregroundColor(enabledShape == shape ? .white : .white.opacity(0.08))
//                .overlay(
//                    shapeImage(shape)
//                        .resizable()
//                        .frame(width: 32, height: 32)
//                        .foregroundColor(enabledShape == shape ? .black : Color(hex: 0x7D7B76))
//                )
        }
    }
    
    func selectedShape(_ shape: ShapeType) -> Image {
        switch shape {
        case .plane:
            return Images.buttonPlaneSelected.swiftUIImage
        case .cube:
            return Images.buttonCubeSelected.swiftUIImage
        case .sphere:
            return Images.buttonSphereSelected.swiftUIImage
        }
    }
    
    func unselectedShape(_ shape: ShapeType) -> Image {
        switch shape {
        case .plane:
            return Images.buttonPlane.swiftUIImage
        case .cube:
            return Images.buttonCube.swiftUIImage
        case .sphere:
            return Images.buttonSphere.swiftUIImage
        }
    }
}
