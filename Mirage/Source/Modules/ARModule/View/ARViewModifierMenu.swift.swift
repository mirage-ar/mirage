//
//  ModifierNavigation.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct ARViewModifierMenu: View {
    @StateObject var viewModel: ARViewModel
    
    var body: some View {
        HStack {
            
            Button {
                viewModel.removeModifier(viewModel.sceneData.selectedModifier)
                viewModel.sceneData.selectedModifier = .none
            } label: {
                Text("W/O")
                    .foregroundColor(viewModel.sceneData.selectedModifier == .none ? .white : .gray)
                    .font(.subtitle2)
            }
            .padding(.trailing)
            
//            Button {
//                viewModel.applyModifier(.TRANSPARENCY)
//            } label: {
//                Text("M1")
//                    .font(.system(size: 16)) // TODO: convert to standard font
//                    .foregroundColor(viewModel.sceneData.selectedModifier == .TRANSPARENCY ? .white : .gray)
//            }
//            .padding([.leading, .trailing])
            
            Button {
                viewModel.applyModifier(.rotate)
            } label: {
                Text("SPIN")
                    .foregroundColor(viewModel.sceneData.selectedModifier == .rotate ? .white : .gray)
                    .font(.subtitle2)
            }
            .padding(.leading)
            
        }
    }
}

// TODO: write adjustment slider
//struct ModifierAdjustmentSlider: View {
//    @EnvironmentObject var viewModel: viewModel
//
//    var body: some View {
//        Slider(
//            value: $viewModel.modiferAmount,
//            in: 0...100,
//            onEditingChanged: { editing in
//                print("editing")
//            }
//        )
//        .tint(.white)
//        .frame(width: UIScreen.main.bounds.width * 0.70)
//    }
//}

