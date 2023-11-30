//
//  String+Extension.swift
//  Mirage
//
//  Created by Saad on 06/03/2023.
//

import Foundation
import UIKit

extension String {
    var boolValue: Bool {
        switch self {
        case "1":
            return true
        default:
            return false
        }
    }
}

extension String {
    public var removedWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {

    public static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    public static var deviceIdKey = "device-id"
}

private extension String {
    static var wifiInterfaces: [String] {
        ["en0"]
    }

    static var wiredInterfaces: [String] {
        ["en2", "en3", "en4"]
    }

    static var cellularInterfaces: [String] {
        ["pdp_ip0", "pdp_ip1", "pdp_ip2", "pdp_ip3"]
    }
}
extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale

        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }

        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}
