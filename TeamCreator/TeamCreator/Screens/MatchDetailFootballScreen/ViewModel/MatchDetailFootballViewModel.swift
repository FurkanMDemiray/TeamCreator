//
//  MatchDetailTeamViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 6.08.2024.
//

import Foundation

protocol MatchDetailFootballViewModelDelegate: AnyObject { }

protocol MatchDetailFootballViewModelProtocol {
    var delegate: MatchDetailFootballViewModelDelegate? { get set }
    var getTeam: [Player] { get set }
}

final class MatchDetailFootballViewModel {
    weak var delegate: MatchDetailFootballViewModelDelegate?
    private var team = [Player]()
}

extension MatchDetailFootballViewModel: MatchDetailFootballViewModelProtocol {
    var getTeam: [Player] {
        get {
            return team
        }
        set {
            team = newValue
        }
    }
}
