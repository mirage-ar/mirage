//
//  UserProfileView.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import SwiftUI

struct UserProfileView: View {
    @State var goToSettings = false
    @State var goToEditProfile = false
    @State var ownProfile = true
    @State var goToHome = false
    @Environment(\.presentationMode) var presentationMode
    //TODO: get rid off these two lines. Not required here.
    @State var showCollectedByList = false
    @State var selectedMira: Mira 

    @ObservedObject private var viewModel = UserProfileViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack(alignment: .bottom) {
                        VStack {
                            AsyncImage(url: URL(string: viewModel.user.profileImage)) { image in
                                //                        AsyncImage(url: URL(string: "https://i.pinimg.com/736x/73/6d/65/736d65181843edcf06c220cbf79933fb.jpg")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                                    .foregroundColor(Colors.white8p.swiftUIColor)
                            }
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 436, alignment: .top)
                        .clipped()
                        
                        HStack() {
                            VStack (alignment: .leading) {
                                Group {
                                    Text(viewModel.user.userName ?? "NaN")
                                        .font(Font.title)
                                    if (ownProfile && viewModel.user.isDescriptionEmpty) {
                                        Button {
                                            goToEditProfile = true
                                            
                                        } label: {
                                            Text("EDIT PROFILE")
                                                .frame(maxWidth: .infinity)
                                        }
                                        .background(Colors.white.swiftUIColor)
                                        .foregroundColor(Colors.black.swiftUIColor)
                                        .cornerRadius(10)
                                        .frame(width: 150)
                                        .hiddenConditionally(isHidden: viewModel.user.isDescriptionEmpty)
                                        
                                    } else {
                                        Text(viewModel.user.profileDescription ?? "")
                                            .font(Font.body)
                                    }
                                }
                                .foregroundColor(Colors.white.swiftUIColor)
                                
                            }
                            Spacer()
                            
                        }
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Colors.black.swiftUIColor, .clear]), startPoint: .bottom, endPoint: .top)
                        )
                        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .bottom)
                        
                    }
                    .background(Colors.black.swiftUIColor)
                    
                    
                    HStack {
                        VStack {
                            ZStack {
                                MBMapView(selectedMira: $selectedMira, showCollectedByList: $showCollectedByList)
                                    .opacity(0.7)
                                VStack {
                                    HStack(alignment: .top){
                                        Text("Collection")
                                            .foregroundColor(Colors.white.swiftUIColor)
                                            .font(Font.body)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        
                                    }
                                    .padding(.leading, 5)
                                    .padding(.top, 5)
                                    Spacer()
                                    ZStack {
                                        Rectangle()
                                            .cornerRadius(20)
                                            .foregroundColor(Colors.green.swiftUIColor)
                                            .frame(width:80, height: 40)
                                        HStack {
                                            Text("12")
                                            Images.new16.swiftUIImage
                                                .renderingMode(.template)
                                                .foregroundColor(Colors.black.swiftUIColor)
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                
                            }
                            .frame(maxHeight: 160)
                            .disabled(true)
                            .cornerRadius(10)
                        }
                        VStack{
                            HStack {
                                Text("Miras")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Colors.white.swiftUIColor)
                                    .font(Font.body)
                                Spacer()
                                Text("12")
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(Colors.white.swiftUIColor)
                                    .font(Font.body)
                            }
                            .padding(.top, -70) //to bind the view at top
                            .padding(.leading, 5)
                            Divider()
                                .overlay(Colors.g3Grey.swiftUIColor)
                                .padding(.top, -55)
                                .padding(.leading, 5)
                            
                        }
                        
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            presentationMode.wrappedValue.dismiss()

                        } label: {
                            Images.goHome32.swiftUIImage
                        }
                        .padding(.trailing, 30)
                        
                    }
                    .padding(.bottom, 50)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Button go to Home")
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Images.arrowB24.swiftUIImage
                            .resizable()
                            .scaledToFit()
                        
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Button go to Settings")
                        goToSettings = true
                    } label: {
                        Images.settings24.swiftUIImage
                            .resizable()
                            .scaledToFit()
                        
                    }

                }

            }
            .background(Colors.black.swiftUIColor)
            .navigationDestination(isPresented: $goToSettings) {
                NavigationRoute.settings(user: viewModel.user).screen
            }
            .navigationDestination(isPresented: $goToEditProfile) {
                NavigationRoute.editProfile(user: .dummyUser()).screen
            }
            .edgesIgnoringSafeArea(.all)
        }
        .accentColor(Colors.white.swiftUIColor)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(selectedMira: .dummy)
    }
}
