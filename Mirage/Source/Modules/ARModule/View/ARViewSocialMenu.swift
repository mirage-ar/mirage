//
//  ARViewSocialMenu.swift
//  Mirage
//
//  Created by fiigmnt on 6/19/23.
//

import SwiftUI

struct ARViewSocialMenu: View {
//    @EnvironmentObject var stateManager: StateManager
    @StateObject var viewModel: ARViewModel
    @Binding var selectedUserOnMap: User?
    
    let buttonSize = 32.0
    let userId: UUID?

    var body: some View {
        VStack {
            Spacer()
            HStack {
                // TODO: delete mira button
//                if viewModel.selectedMira?.creator.id == viewModel.creator?.id {
//                    Button {
//                        viewModel.deleteMira()
//                    } label: {
//                        Text("DELETE")
//                    }
//                }
                Spacer()
                VStack {
                    Button {
                        print("View Profile")
                        selectedUserOnMap = viewModel.selectedMira?.creator
                    } label: {
                        AsyncImage(url: URL(string: viewModel.selectedMira?.creator.profileImage ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        .background(Colors.g3Grey.just)
                        .clipShape(Circle())
                    }

                    Button {
                        print("Collect Mira")
                        if let id =  viewModel.selectedMira? .id {
                            viewModel.collectMira(id:id)
                        }
                        
                    } label: {
                        // TODO: turn green when mira is collected
                        Images.collectMiraWhite.swiftUIImage
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize)
                            .foregroundColor($viewModel.collected.wrappedValue ? Colors.green.swiftUIColor : Colors.white.swiftUIColor)
                    }
                    
                    Button {
                        debugPrint("UPDATE: Social Menu - more")
                    } label: {
                        Images.more32.swiftUIImage
                    }
                }
            }
        }
        .onAppear {
            print("COLLECTORS")
            viewModel.selectedMira?.collectors.map { print("\($0)") }
            $viewModel.collected.wrappedValue = viewModel.checkIfMiraIsCollected(userID: userId ?? UUID())
        }
    }
}
