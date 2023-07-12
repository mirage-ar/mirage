//
//  EditProfileView.swift
//  Mirage
//
//  Created by Saad on 09/05/2023.
//

import SwiftUI

struct EditProfileView: View {
    @State var bioText = "Ny Based CG Artist\ninst: @xyz\nMusic Lover\nAthlete"
    @State var gotoEditUserName = false
    @State var gotoEditBio = false
    @State var showMediaPicker = false
    @State var user: User
    @ObservedObject private var viewModel = EditUserProfileViewModel()
    @State var media: Media?

    
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
                        
            VStack {
                ZStack {
                    Button {
                        showMediaPicker = true
                        print("Edit Image")
                    } label: {
                        
                        Group {
                            if let image = media?.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)

                            } else {
                                AsyncImage(url: URL(string: user.profileImage)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                        .foregroundColor(Colors.white8p.swiftUIColor)
                                }

                            }
                        }
                        .frame(width: 150, height: 150)
                        .cornerRadius(75)
                        .scaledToFill()

                    }
                    Images.refresh.swiftUIImage
                        .padding(.top, 150)
                        .onTapGesture {
                            showMediaPicker = true
                        }
                    
                }
                .padding(.all, 50)
               
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("UserName")
                                .font(.body1)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                            Spacer()

                        }
                        HStack {
                            Text(user.userName ?? "")
                                .font(.body1)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Colors.white.swiftUIColor)
                            Spacer()
                        }
                        .padding(.leading, 5)

                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        gotoEditUserName = true
                    }
                    
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)
                    
                    //Temporarily Hidden for MPV Version
                    /*
                    VStack(spacing: 5) {
                        Text("Pronouns")
                            .font(.body1)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                        
                        Text("She/They")
                            .font(.body1)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.white.swiftUIColor)
                        
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)
                    */
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bio")
                            .font(.body)
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                        
                        TextEditor(text: $bioText)
                            .foregroundColor(Colors.white.swiftUIColor)
                            .background(.clear)
                            .scrollContentBackground(.hidden)
                            .frame(maxHeight: 100)
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        gotoEditBio = true
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)

                    
                }
                Spacer()
                
                VStack {
                    Button {
                        viewModel.signoutUser()
                        AppConfiguration.shared.authentication = false
                    } label: {
                        Text("SIGNOUT")
                            .font(.body1)
                            .foregroundColor(Colors.white.swiftUIColor)
                    }
                    
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)

                    Button {
                        
                    } label: {
                        Text("DELETE ACCOUNT")
                            .font(.body1)
                            .foregroundColor(Colors.red.swiftUIColor)
                    }

                    
                }

            }

            
        }
        .onAppear() {
            bioText = user.profileDescription ?? ""
        }
        .navigationTitle("EDIT PRPFILE")
        .navigationDestination(isPresented: $gotoEditUserName) {
            NavigationRoute.updateUser(title: "USERNAME", value: user.userName ?? "", user: user).screen
        }
        .navigationDestination(isPresented: $gotoEditBio) {
            NavigationRoute.updateUser(title: "BIO", value: user.profileDescription ?? "", user: user).screen
        }
        .sheet(isPresented: $showMediaPicker, onDismiss: loadMedia) {
            MediaPicker(media: $media)
        }

    }
    func loadMedia() {
        guard let media = media else { return }
        if let image = media.image{
            DownloadManager.shared.upload(image: image) { url in
                if let url = url, var user = UserDefaultsStorage().getUser() {
                    user.profileImage = url
                    viewModel.update(user: user)

                }
            }

        }
    }

}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .dummy)
    }
}
