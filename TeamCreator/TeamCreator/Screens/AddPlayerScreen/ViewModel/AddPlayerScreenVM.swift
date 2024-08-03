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
    var selectedSport: Sport? {
        didSet {
            setupPositions()
        }
    }
    private var positions = [String]()
    private let sportPositions: [Sport: [String]] = [
        .football: FootballPosition.allCases.map { $0.rawValue },
        .volleyball: VolleyballPosition.allCases.map { $0.rawValue }
    ]
    let firebaseManager: FirebaseManagerProtocol

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        self.firebaseManager = firebaseManager
    }
    
    private func setupPositions() {
        guard let sport = selectedSport else { return }
        positions = sportPositions[sport] ?? []
    }
    
}

extension AddPlayerScreenVM: AddPlayerScreenVMProtocol {
    func viewDidLoad() {
        view?.setupVC()
        view?.setupImageView()
        view?.setupPickerView()
    }

    func numberOfRows() -> Int {
        positions.count
    }

    func titleForRow(row: Int) -> String {
        positions[row]
    }

    func addPlayer(player: Player) {
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
    }
}
