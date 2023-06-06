//
//  BottomBar.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import SwiftUI

struct BottomBar: View {
    @EnvironmentObject var stateManager: StateManager

    @Environment(\.presentationMode) var presentationMode

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

                } else if stateManager.miraCreateMenuType == .DEFAULT || stateManager.arViewMode == .VIEW {
                    // show close icon
                    HStack {
                        if stateManager.arViewMode == .VIEW && stateManager.arViewLocalized == false {
                            Spacer()
                            Button {
                                stateManager.arViewMode = .CREATE
                            } label: {
                                Text("SKIP SCAN")
                                    .foregroundColor(.white)
                                    .subTitle()
                            }
                        } else if stateManager.arViewMode == .CREATE {
                            if stateManager.arViewLocalized == false {
                                Images.notInZone24.swiftUIImage
                            }
                            Spacer()
                            Button {
                                stateManager.arViewMode = .VIEW
                            } label: {
                                Images.arExplore24.swiftUIImage
                            }
                        }
                        Spacer()
                        Button {
                            // close AR view
                            presentationMode.wrappedValue.dismiss()
                            stateManager.arViewMode = .VIEW
                        } label: {
                            Images.arrowB24.swiftUIImage
                        }
                    }
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
                        Images.buttonClose.swiftUIImage
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
                        Images.buttonCheck.swiftUIImage
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
}
