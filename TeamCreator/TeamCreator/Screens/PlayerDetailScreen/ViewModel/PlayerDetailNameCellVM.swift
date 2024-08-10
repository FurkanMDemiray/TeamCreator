//
//  PlayerDetailNameCellVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import Foundation

final class PlayerDetailNameCellVM: CellVM {
    private var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
    
    var playerLabel: String {
        name ?? ""
    }
}
