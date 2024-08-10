//
//  PlayerDetailSkillCellVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import Foundation

final class PlayerDetailSkillCellVM: CellVM {
    private var skill: Int?
    
    init(skill: Int? = nil) {
        self.skill = skill
    }
    
    var playerSkill: String {
        String(skill ?? 1)
    }
}
