//
//  FootballPosition.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 3.08.2024.
//

import Foundation

enum FootballPosition: String, CaseIterable, Codable {
    case gk = "Goalkeeper"
    case lb = "Left Back"
    case cb = "Center Back"
    case rb = "Right Back"
    case cm = "Center Midfielder"
    case lw = "Left Winger"
    case rw = "Right Winger"
    case cf = "Center Forward"
}
