//
//  CollectedByUsersView.swift
//  Mirage
//
//  Created by Saad on 21/06/2023.
//

import SwiftUI

struct CollectedByUsersView: View {
//    @ObservedObject private var viewModel: CollectedByUsersViewModel
    let selectedMira: Mira

//    init(mira: Mira) {
//        selectedMira = mira
////        viewModel = CollectedByUsersViewModel(mira: mira)
//    }
    var body: some View {
        ZStack {
            Colors.black40p.swiftUIColor
                .edgesIgnoringSafeArea(.all)
                
            VStack {
                HStack {
                    Images.new16.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(" \(selectedMira.collectors?.count ?? 0)")
                        .font(.body)
                    Spacer()
                    Text(selectedMira.creator.userName ?? "NaN")

                }
                Spacer()
            }
        }
    }
}

struct CollectedByUsersView_Previews: PreviewProvider {
    static var previews: some View {
        CollectedByUsersView(selectedMira: Mira.dummy)
    }
}
