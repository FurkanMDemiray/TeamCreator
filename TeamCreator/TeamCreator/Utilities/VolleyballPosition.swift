//
//  VolleyballPosition.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 3.08.2024.
//

import Foundation

enum VolleyballPosition: String, CaseIterable, Codable {
    case rsh = "Right Side Hitter"
    case mdb = "Middle Blocker"
    case opp = "Opposite"
    case set = "Setter"
    case lib = "Libero"
    case osh = "Outside Hitter"
}
