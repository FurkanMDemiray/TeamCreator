//
//  PlayerCellVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 30.07.2024.
//

import Foundation

final class PlayerCellVM {
    private let player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    var playerName: String? {
        player.name
    }
    
    var playerPosition: String? {
        player.position
    }
    
    var playerSkill: Int? {
        player.skillPoint
    }
    
}
