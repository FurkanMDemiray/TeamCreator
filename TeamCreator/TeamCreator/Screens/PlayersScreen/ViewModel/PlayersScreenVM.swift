//
//  PlayerScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 30.07.2024.
//

import Foundation

protocol PlayersScreenVMDelegate: AnyObject {
    func navigateToAddPlayers()
}

protocol PlayersScreenVMProtocol {
    var delegate: PlayersScreenVMDelegate? { get set }
    func viewWillAppear()
    func viewDidLoad()
    func numberOfRows() -> Int
    func cellForRow(at indexPath: IndexPath) -> PlayerCellVM
    func deletePlayer(at indexPath: IndexPath)
    func addButtonTapped()
}

final class PlayersScreenVM {
    weak var view: PlayersScreenVCProtocol?
    weak var delegate: PlayersScreenVMDelegate?
    var selectedSport: Sport?
    var players = [Player]()
    
    let firebaseManager: FirebaseManagerProtocol

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        self.firebaseManager = firebaseManager
    }
    
    private func fetchPlayers() {
        firebaseManager.fetchPlayers { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.players = data
                    self.view?.reloadTableView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension PlayersScreenVM: PlayersScreenVMProtocol {
    
    func viewWillAppear() {
        fetchPlayers()
        print(players)
    }
    
    func viewDidLoad() {
        view?.setupNavBar()
        view?.registerTableView()
    }
    

    func numberOfRows() -> Int {
        return players.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> PlayerCellVM {
        let playerCellVM = PlayerCellVM(player: players[indexPath.row])
        return playerCellVM
    }
    
    func deletePlayer(at indexPath: IndexPath) {
        let player = players[indexPath.row]
        firebaseManager.deletePlayer(player: player) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.players.remove(at: indexPath.row)
                    self?.view?.reloadTableView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addButtonTapped() {
        delegate?.navigateToAddPlayers()
    }
}

