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
    func addPlayer(player: Player)
}

final class AddPlayerScreenVM {
    weak var view: AddPlayersScreenVCProtocol?
    weak var delegate: AddPlayerScreenVMDelegate?
    var selectedSport: Sport?
    private var position = ["Goalkeeper", "Defence", "Midfielder", "Attacker"]
    let firebaseManager: FirebaseManagerProtocol

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        self.firebaseManager = firebaseManager
    }
}

extension AddPlayerScreenVM: AddPlayerScreenVMProtocol {
    func viewDidLoad() {
        view?.setupVC()
        view?.setupImageView()
        view?.setupPickerView()
    }

    func numberOfRows() -> Int {
        position.count
    }

    func titleForRow(row: Int) -> String {
        position[row]
    }

    func addPlayer(player: Player) {
       /* guard let name = player.name, !name.isEmpty,
            let position = player.position, !position.isEmpty,
            let skill = player.skillPoint,
            let sport = selectedSport?.rawValue else {
            view?.showError(message: "Please fill out all fields correctly")
            return
        }*/


        firebaseManager.addPlayer(player: player) { result in
            switch result {
            case .success:
                self.view?.clearFields()
                self.delegate?.navigateBackToPlayers()
            case .failure(let error):
                print("error adding players \(error.localizedDescription)")
                self.view?.showError(message: "Failed to add player. Try Again.")
            }
        }

        /*let playerData: [String: Any] = [
            "name": name,
            "position": position,
            "skill": skill
        ]
        
        db.collection("sports").document(sport).collection("players").addDocument(data: playerData) { error in
                if let error = error {
                    print("error adding players \(error.localizedDescription)")
                    self.view?.showError(message: "Failed to add player. Try Again.")
                } else {
                    print("added players success")
                    self.view?.clearFields()
                    self.delegate?.navigateBackToPlayers()
                }
            }
         */

    }
}
