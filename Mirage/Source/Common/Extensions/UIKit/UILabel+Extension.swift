//
//  UILabel+Extension.swift
//  Mirage
//
//  Created by Saad on 08/06/2023.
//

import UIKit

extension UILabel {
    func setFont(_ font: FontType = .subtitle2, textColor: ColorAsset = Colors.white) {
        self.font = FontConvertible.Font.customUIKit(type: font)
        self.textColor = textColor.color
    }
}
