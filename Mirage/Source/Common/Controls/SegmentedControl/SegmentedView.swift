//
//  SegmentedView.swift
//  Mirage
//
//  Created by Saad on 13/11/2023.
//

import SwiftUI

struct SegmentedView: View {

    let segments: [String]
    @Binding var selected: Int
    @Namespace var name
    @State var selectedColor = Colors.white.swiftUIColor
    @State var textColor = Colors.white40p.swiftUIColor
    let indexChanged: (Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button {
                    selected = segments.firstIndex(of: segment) ?? 0
                    indexChanged(selected)
                } label: {
                    VStack {
                        Text(segment)
                            .font(.body1)
                            .fontWeight(.medium)
                            .foregroundColor( segments[selected] == segment ? selectedColor : textColor)
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if segments[selected] == segment {
                                Capsule()
                                    .fill(selectedColor)
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
    }
}
