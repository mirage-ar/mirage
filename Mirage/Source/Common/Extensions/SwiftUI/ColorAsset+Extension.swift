//
//  ColorAsset+Extension.swift
//  Mirage
//
//  Created by Saad on 22/03/2023.
//

import SwiftUI

extension Color {
    init(_ asset: ColorAsset) {
        self.init(asset.name, bundle: .main)
    }
}

extension ColorAsset {
    var just: SwiftUI.Color {
        SwiftUI.Color(self)
    }
}
