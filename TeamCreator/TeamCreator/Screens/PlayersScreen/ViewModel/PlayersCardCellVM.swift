//
//  PlayerCardVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import Foundation

final class PlayersCardCellVM {
    let player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    var playerName: String? {
        player.name
    }
    
    var playerPosition: String? {
        player.position
    }
    
    var playerRating: String? {
        String(describing: player.skillPoint ?? 0)
    }
    
    var playerImage: String? {
        player.picture
    }
}
