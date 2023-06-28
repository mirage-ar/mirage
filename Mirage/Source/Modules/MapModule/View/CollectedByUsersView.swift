//
//  CollectedByUsersView.swift
//  Mirage
//
//  Created by Saad on 21/06/2023.
//

import SwiftUI

struct CollectedByUsersView: View {
//    @ObservedObject private var viewModel: CollectedByUsersViewModel
    @Binding var selectedMira: Mira?
    @Binding var selectedUser: User?

    let paddingMargin = 20.0
//    init(mira: Mira) {
//        selectedMira = mira
////        viewModel = CollectedByUsersViewModel(mira: mira)
//    }
    
    
    var body: some View {
        ZStack {
            Colors.black70p.swiftUIColor
                .edgesIgnoringSafeArea(.all)
                
            List {
                Section {
                    if let selectedMira = selectedMira {
                        ForEach(selectedMira.collectors ?? [], id: \.self) { user in
                            UserListRow(user: user)
                            //                            .background(.clear)
                            //                            .edgesIgnoringSafeArea(.all)
                                .listRowBackground(Color.clear)
                                .padding([.leading, .trailing], -paddingMargin)
                            
                            // replaced List selection (not available on iOS)
                                .onTapGesture {
                                    print("UPDATE: selected user set to: \(String(describing: user.userName))")
                                    self.selectedUser = user
                                }
                        }
                    }
                } header: {
                    VStack(alignment: .leading) {
                        HStack(spacing: 1) {
                            Images.collectMiraWhite.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            Text("\(selectedMira?.collectors?.count ?? 0)")
                                .font(.body1)
                            Spacer()
                            Button {
                                selectedUser = selectedMira?.creator
                            } label: {
                                Text("Mira by " + (selectedMira?.creator.userName ?? "NaN"))
                                    .font(.body2)
                                Images.arrowR24.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }

                        }
                        .padding([.leading, .trailing], -paddingMargin)
                        Divider()
                            .overlay(Colors.g4LightGrey.swiftUIColor)
                            .padding([.trailing, .leading], -paddingMargin)
                        Text("Collected By")
                            .font(.body2)
                            .padding([.leading, .trailing], -paddingMargin)

                        Spacer()
                    }
                    

                } footer: {
                    LargeButton(title: "Navigate") {
                        print("google map")
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

