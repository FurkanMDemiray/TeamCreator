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
    var players = [Players]()
    
}

extension PlayersScreenVM: PlayersScreenVMProtocol {
    
    func viewDidLoad() {
        fetchPlayers()
        view?.setupNavBar()
        view?.registerTableView()
    }
    
    private func fetchPlayers() {
        players.append(Players(name: "name1", position: "pos1", skill: "10"))
        players.append(Players(name: "name2", position: "pos2", skill: "11"))
        players.append(Players(name: "name3", position: "pos3", skill: "12"))
        players.append(Players(name: "name4", position: "pos4", skill: "13"))
        players.append(Players(name: "name5", position: "pos5", skill: "14"))
        players.append(Players(name: "name6", position: "pos6", skill: "15"))
        players.append(Players(name: "name7", position: "pos7", skill: "16"))
        
        DispatchQueue.main.async {
            self.view?.reloadTableView()
        }
    }
    
    func numberOfRows() -> Int {
        return players.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> PlayerCellVM {
        let playerCellVM = PlayerCellVM(player: players[indexPath.row])
        return playerCellVM
    }
    
    func deletePlayer(at indexPath: IndexPath) {
        players.remove(at: indexPath.row)
        view?.reloadTableView()
    }
    
    func addButtonTapped() {
        delegate?.navigateToAddPlayers()
    }
}

//Silinecek
struct Players {
    var name, position, skill: String?
}
