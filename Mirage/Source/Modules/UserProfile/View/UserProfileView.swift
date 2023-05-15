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
    
    @ObservedObject private var viewModel = UserProfileViewModel()

    var body: some View {
        ZStack {
            VStack {

                ZStack(alignment: .bottom) {

                    VStack {
                        ZStack {
                            HStack {
                                Spacer()
                                Button {
                                    print("Button go to Settings")
                                    goToSettings = true
                                } label: {
                                    Images.settings24.swiftUIImage
                                        .resizable()
                                        .scaledToFit()
                                    
                                }
                                .frame(width: 24, height: 24)
                            }
                        }

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
                    .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .top)
                    .clipped()
                    
                    HStack() {
                        VStack (alignment: .leading) {
                            Group {
                                Text("#" + (viewModel.user.userName ?? "NaN"))
                                    .font(Font.title)
                                if (ownProfile && viewModel.user.isDescriptionEmpty) {
                                    Button {
                                        goToEditProfile = true

                                    } label: {
                                        Text("Edit Profile")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .background(Colors.white.swiftUIColor)
                                    .foregroundColor(Colors.black.swiftUIColor)
                                    .cornerRadius(10)
                                    .frame(width: 150)
                                    .hiddenConditionally(isHidden: viewModel.user.isDescriptionEmpty)
                                    
                                } else {
                                    Text(viewModel.user.bio ?? "")
                                        .font(Font.body)
                                }
                            }
                            .foregroundColor(Colors.white.swiftUIColor)
                            
                        }
                        Spacer()

                    }
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Colors.black.swiftUIColor, .clear]), startPoint: .bottom, endPoint: .top)
                    )
                    .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .bottom)
                    
                }
                .background(Colors.black.swiftUIColor)
                
                
                HStack {
                    ZStack {
                        VStack {
                            Text("Collection")
                                .foregroundColor(Colors.white.swiftUIColor)
                                .font(Font.body)


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
                        }

                    }
                    Spacer()
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
                }
                Spacer()
            }
        }
        .background(Colors.black.swiftUIColor)
        .navigationDestination(isPresented: $goToSettings) {
            NavigationRoute.settings.screen
        }
        .navigationDestination(isPresented: $goToEditProfile) {
            NavigationRoute.editProfile(user: .dummyUser()).screen
        }
        
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
