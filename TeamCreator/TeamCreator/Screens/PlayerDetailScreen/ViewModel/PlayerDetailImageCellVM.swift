//
//  PlayerDetailImageCellVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import Foundation

protocol CellVM{}

final class PlayerDetailImageCellVM: CellVM {
    private var image: String?
    
    init(image: String? = nil) {
        self.image = image
    }
    
    var playerImage: String {
        return image ?? ""
    }
}
