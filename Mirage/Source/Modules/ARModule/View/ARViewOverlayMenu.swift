//
//  ARViewOverlayMenu.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct OverlayMenu: View {
    @EnvironmentObject var stateManager: StateManager
    let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        switch stateManager.miraCreateMenuType {
        case .DEFAULT:
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        haptic()
                        stateManager.miraCreateMenuType = .MODIFY
                    } label: {
                        Image("button-modify")
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    
                    Button {
                        haptic()
                        stateManager.miraCreateMenuType = .SHAPE
                    } label: {
                        Image("button-shape")
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    Spacer()
                }
                    
                HStack {
                    Spacer()
                        
                    Button {
                        haptic()
                            
                        if let entity = stateManager.sceneData.selectedEntity?.entity {
                            stateManager.removeEntity(entity)
                        }
                    } label: {
                        Image("button-trash")
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
                ShapeButton(shape: .PLANE, enabledShape: $stateManager.sceneData.selectedShape, buttonAction: stateManager.applyShape)
                
                ShapeButton(shape: .CUBE, enabledShape: $stateManager.sceneData.selectedShape, buttonAction: stateManager.applyShape)
                
                ShapeButton(shape: .SPHERE, enabledShape: $stateManager.sceneData.selectedShape, buttonAction: stateManager.applyShape)
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
        case .PLANE:
            return Image("button-plane-selected")
        case .CUBE:
            return Image("button-cube-selected")
        case .SPHERE:
            return Image("button-sphere-selected")
        }
    }
    
    func unselectedShape(_ shape: ShapeType) -> Image {
        switch shape {
        case .PLANE:
            return Image("button-plane")
        case .CUBE:
            return Image("button-cube")
        case .SPHERE:
            return Image("button-sphere")
        }
    }
}
