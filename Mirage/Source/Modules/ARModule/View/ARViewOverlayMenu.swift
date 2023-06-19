//
//  ARViewOverlayMenu.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct ARViewOverlayMenu: View {
    @StateObject var viewModel: ARViewModel
    
    let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        if viewModel.arViewMode == .CREATE {
            if viewModel.sceneData.selectedEntity != nil {
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
                        ShapeButton(shape: .PLANE, enabledShape: $viewModel.sceneData.selectedShape, buttonAction: viewModel.applyShape)
                    
                        ShapeButton(shape: .CUBE, enabledShape: $viewModel.sceneData.selectedShape, buttonAction: viewModel.applyShape)
                    
                        ShapeButton(shape: .SPHERE, enabledShape: $viewModel.sceneData.selectedShape, buttonAction: viewModel.applyShape)
                    }
                }
            } else {
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
        } else if viewModel.selectedMira != nil {
            ARViewSocialMenu()
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
        case .PLANE:
            return Images.buttonPlaneSelected.swiftUIImage
        case .CUBE:
            return Images.buttonCubeSelected.swiftUIImage
        case .SPHERE:
            return Images.buttonSphereSelected.swiftUIImage
        }
    }
    
    func unselectedShape(_ shape: ShapeType) -> Image {
        switch shape {
        case .PLANE:
            return Images.buttonPlane.swiftUIImage
        case .CUBE:
            return Images.buttonCube.swiftUIImage
        case .SPHERE:
            return Images.buttonSphere.swiftUIImage
        }
    }
}
