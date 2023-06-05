//
//  BottomBar.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct BottomBar: View {
    @EnvironmentObject var stateManager: StateManager

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.bottom)

            HStack {
                // Left Button
                if stateManager.miraCreateMenuType == .DEFAULT && stateManager.sceneData.selectedEntity != nil {
                    Spacer()
                    Button {
                        stateManager.sceneData.selectedEntity = nil
                    } label: {
                        Text("DONE")
                            .foregroundColor(.white)
                            .subTitle()
                    }

                } else if stateManager.miraCreateMenuType == .DEFAULT {
                    // show nothing
                } else {
                    // TODO: adding this as a tempory solution to save
//                    HStack {

                    Button {
                        if stateManager.miraCreateMenuType == .MODIFY {
                            stateManager.sceneData.selectedModifier = stateManager.sceneData.previousModifier
                            stateManager.removeModifier(.SPIN)
                        }

                        if stateManager.miraCreateMenuType == .SHAPE {
                            stateManager.sceneData.selectedShape = stateManager.sceneData.previousShape
                            stateManager.revertShape(stateManager.sceneData.previousShape)
                        }

                        stateManager.miraCreateMenuType = .DEFAULT

                    } label: {
                        Image("button-close")
                    }

//                        Spacer()
//
//                        Button {
//                            print("Save Mira")
//                        } label: {
//                            Text("Save")
//                        }
//
//                    }
                }

//                Spacer()

                // Middle Section
                if stateManager.miraCreateMenuType == .MODIFY {
                    Spacer()
                    ModifierMenu()
                    Spacer()
                } else if stateManager.miraCreateMenuType == .SHAPE {
                    Spacer()
                    Text("SHAPE")
                        .foregroundColor(.white)
                        .subTitle()
                    Spacer()
                }

                // Right Button
                if stateManager.miraCreateMenuType == .MODIFY || stateManager.miraCreateMenuType == .SHAPE {
                    Button {
                        if stateManager.miraCreateMenuType == .MODIFY {
                            stateManager.sceneData.previousModifier = stateManager.sceneData.selectedModifier
                        }

                        if stateManager.miraCreateMenuType == .SHAPE {
                            stateManager.sceneData.previousShape = stateManager.sceneData.selectedShape
                        }

                        stateManager.miraCreateMenuType = .DEFAULT

                    } label: {
                        Image("button-check")
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
}
