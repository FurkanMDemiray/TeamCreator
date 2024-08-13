//
//  VolleyballViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 6.08.2024.
//

import Foundation

protocol VolleyballViewModelDelegate: AnyObject { }

protocol VolleyballViewModelProtocol {
    var delegate: VolleyballViewModelDelegate? { get set }
    var getTeam: [Player] { get set }
}

final class VolleyballViewModel {
    weak var delegate: VolleyballViewModelDelegate?
    private var team = [Player]()
}

extension VolleyballViewModel: VolleyballViewModelProtocol {
    var getTeam: [Player] {
        get {
            return team
        }
        set {
            team = newValue
        }
    }
}
