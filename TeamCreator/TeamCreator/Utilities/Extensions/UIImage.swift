//
//  UIImage.swift
//  TeamCreator
//
//  Created by Melik Demiray on 7.08.2024.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from binaryString: String?) {
        // encode
        guard let binaryString = binaryString else { return }
        let imageData = Data(base64Encoded: binaryString, options: .ignoreUnknownCharacters)
        // decode
        guard let data = imageData else { return }
        let image = UIImage(data: data)
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
