//
//  Player.swift
//  TeamCreator
//
//  Created by Melik Demiray on 3.08.2024.
//

import Foundation

struct Player: Codable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String
    var name: String?
    var age: Int?
    var skillPoint: Int?
    var position: String?
    var sport: String?
    var picture: String?
}
