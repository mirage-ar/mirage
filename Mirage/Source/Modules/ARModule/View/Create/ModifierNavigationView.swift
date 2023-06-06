//
//  ModifierNavigation.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct ModifierMenu: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        HStack {
            
            Button {
                stateManager.removeModifier(stateManager.sceneData.selectedModifier)
                stateManager.sceneData.selectedModifier = .NONE
            } label: {
                Text("W/O")
                    .foregroundColor(stateManager.sceneData.selectedModifier == .NONE ? .white : .gray)
                    .subTitle()
            }
            .padding(.trailing)
            
//            Button {
//                stateManager.applyModifier(.TRANSPARENCY)
//            } label: {
//                Text("M1")
//                    .font(.system(size: 16)) // TODO: convert to standard font
//                    .foregroundColor(stateManager.sceneData.selectedModifier == .TRANSPARENCY ? .white : .gray)
//            }
//            .padding([.leading, .trailing])
            
            Button {
                stateManager.applyModifier(.SPIN)
            } label: {
                Text("SPIN")
                    .foregroundColor(stateManager.sceneData.selectedModifier == .SPIN ? .white : .gray)
                    .subTitle()
            }
            .padding(.leading)
            
        }
    }
}

struct ModifierAdjustmentSlider: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        Slider(
            value: $stateManager.modiferAmount,
            in: 0...100,
            onEditingChanged: { editing in
                print("editing")
            }
        )
        .tint(.white)
        .frame(width: UIScreen.main.bounds.width * 0.70)
    }
}

