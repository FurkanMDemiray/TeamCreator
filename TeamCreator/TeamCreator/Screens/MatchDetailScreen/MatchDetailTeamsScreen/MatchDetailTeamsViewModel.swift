//
//  MatchDetailTeamsViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import Foundation

protocol MatchDetailTeamsViewModelDelegate: AnyObject {

}

protocol MatchDetailTeamsViewModelProtocol {
    var delegate: MatchDetailTeamsViewModelDelegate? { get set }

    var team1: [Player] { get set }
    var team2: [Player] { get set }
}

final class MatchDetailTeamsViewModel {

    weak var delegate: MatchDetailTeamsViewModelDelegate?
    private var getTeam1 = [Player]()
    private var getTeam2 = [Player]()

    init() {

    }

}

extension MatchDetailTeamsViewModel: MatchDetailTeamsViewModelProtocol {
    var team1: [Player] {
        get {
            getTeam1
        }
        set {
            getTeam1 = newValue
        }
    }

    var team2: [Player] {
        get {
            getTeam2
        }
        set {
            getTeam2 = newValue
        }
    }


}
