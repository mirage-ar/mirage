//
//  Float+Extension.swift
//  Mirage
//
//  Created by Saad on 08/06/2023.
//

import Foundation

public extension Float {
    var formattedStringValue: String {
        return String(format: "%.1f", self)
    }

    var clean: String {
        return String(format: "%.0f", self)
    }
}

public extension Double {
    var formattedStringValue: String {
        return String(format: "%.1f", self)
    }

    var clean: String {
        return String(format: "%.0f", self)
    }
}
