//
//  AddPlayerScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 1.08.2024.
//

import Foundation


protocol AddPlayerScreenVMDelegate: AnyObject {
    func navigateBackToPlayers()
}

protocol AddPlayerScreenVMProtocol {
    var delegate: AddPlayerScreenVMDelegate? { get set }
    func viewDidLoad()
    func numberOfRows() -> Int
    func titleForRow(row: Int) -> String
    func addPlayer(player: Players)
}

final class AddPlayerScreenVM {
    weak var view: AddPlayersScreenVCProtocol?
    weak var delegate: AddPlayerScreenVMDelegate?
    private var position = ["Goalkeeper", "Defence", "Midfielder", "Attacker"]
}

extension AddPlayerScreenVM: AddPlayerScreenVMProtocol {
    func viewDidLoad() {
        view?.setupVC()
        view?.setupPickerView()
    }
    
    func numberOfRows() -> Int {
        position.count
    }
    
    func titleForRow(row: Int) -> String {
        position[row]
    }
    
    func addPlayer(player: Players) {
        guard let name = player.name, !name.isEmpty,
              let position = player.position, !position.isEmpty,
              let skill = player.skill, !skill.isEmpty else {
            view?.showError(message: "Please fill out all fields correctly")
            return
        }
        
        print(name, position, skill)
        view?.clearFields()
        delegate?.navigateBackToPlayers()
    }
}
