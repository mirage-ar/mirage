//
//  ProfileInfoView.swift
//  Mirage
//
//  Created by Saad on 06/11/2023.
//

import SwiftUI

struct ProfileInfoView: View {
    let imageUrl: String
    let userName: String
    let profileDescription: String
    let height: Double
    let width: Double

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        // PROFILE INFO
        ZStack(alignment: .bottom) {
            VStack {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: width,
                            height: dragOffset > 0 ? (height / 2) + dragOffset : (height / 2)
                        )
                        .clipped()
                        .offset(y: dragOffset > 0 ? -dragOffset / 2 : 0.0)
                        .onAppear {
                            debugPrint("image: \(self.imageUrl)")
                        }
                } placeholder: {
                    ProgressView()
                        .foregroundColor(Colors.white8p.swiftUIColor)
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: 350, alignment: .top)
            .clipped()

            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Spacer()
                    Group {
                        Text(userName)
                            .font(.h2)
                            .textCase(.uppercase)
                            .lineLimit(2)
                        Text(profileDescription)
                            .font(.body1)
                    }
                    .foregroundColor(Colors.white.swiftUIColor)
                }
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 150)
            .background(
                LinearGradient(gradient: Gradient(colors: [Colors.black.swiftUIColor, .clear]), startPoint: .bottom, endPoint: .top)
            )
            .gesture(
                DragGesture().onChanged { value in
                    if value.startLocation.y < height, value.translation.height > 0 {
                        dragOffset = value.translation.height
                    }

                    print("DRAG")
                }
                .onEnded { _ in
                    withAnimation {
                        dragOffset = 0
                    }
                }
            )
        }
        .background(Colors.black.swiftUIColor)
    }
}

