//
//  UIImageView+Extension.swift
//  Mirage
//
//  Created by Saad on 26/04/2023.
//

import UIKit

extension UIImageView {
    func setImage(from url: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let urlObj = URL(string: url) else { return }
        setImage(from: urlObj, contentMode: mode)
    }
    func setImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
