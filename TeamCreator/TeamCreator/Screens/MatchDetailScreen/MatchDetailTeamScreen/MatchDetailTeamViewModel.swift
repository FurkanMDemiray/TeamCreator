//
//  MatchDetailTeamViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 6.08.2024.
//

import Foundation

protocol MatchDetailTeamViewModelDelegate: AnyObject {

}

protocol MatchDetailTeamViewModelProtocol {
    var delegate: MatchDetailTeamViewModelDelegate? { get set }
    var getTeam: [Player] { get set }

}

final class MatchDetailTeamViewModel {
    weak var delegate: MatchDetailTeamViewModelDelegate?
    private var team = [Player]()


}

extension MatchDetailTeamViewModel: MatchDetailTeamViewModelProtocol {
    var getTeam: [Player] {
        get {
            return team
        }
        set {
            team = newValue
        }
    }
}
