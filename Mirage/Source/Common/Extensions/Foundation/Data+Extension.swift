//
//  Data+Extension.swift
//  Mirage
//
//  Created by Saad on 06/03/2023.
//

import Foundation


public extension Data {
    func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any]
    }
}
