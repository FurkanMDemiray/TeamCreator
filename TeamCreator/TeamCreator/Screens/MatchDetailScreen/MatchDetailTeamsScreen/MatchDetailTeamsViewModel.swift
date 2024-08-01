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
}

final class MatchDetailTeamsViewModel {

    weak var delegate: MatchDetailTeamsViewModelDelegate?

    init() {

    }

}

extension MatchDetailTeamsViewModel: MatchDetailTeamsViewModelProtocol {

}
