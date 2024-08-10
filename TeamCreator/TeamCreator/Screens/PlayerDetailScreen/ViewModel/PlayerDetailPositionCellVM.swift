//
//  PlayerDetailPositionCellVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import Foundation

final class PlayerDetailPositionCellVM: CellVM {
    private var position: String?
    
    init(position: String? = nil) {
        self.position = position
    }
    
    var playerPosition: String {
        position ?? ""
    }
}
