//
//  PlayerScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 30.07.2024.
//

import Foundation

protocol PlayersScreenVMDelegate: AnyObject {
    func navigateToAddPlayers(with selectedSport: Sport)
    func navigateToDetail(at indexPath: IndexPath, with selectedSport: Sport)
}

protocol PlayersScreenVMProtocol {
    var delegate: PlayersScreenVMDelegate? { get set }
    var view: PlayersScreenVCProtocol? { get set }
    func viewWillAppear()
    func viewDidLoad()
    func numberOfItem(in section: Int) -> Int
    func cellForItem(at indexPath: IndexPath) -> PlayersCardCellVM
    func addButtonTapped()
    func cellTapped(at indexPath: IndexPath)
    func updateCollectionData()
}

final class PlayersScreenVM {
    weak var view: PlayersScreenVCProtocol?
    weak var delegate: PlayersScreenVMDelegate?
    var selectedSport: Sport
    var players = [Player]()

    let firebaseManager: FirebaseManagerProtocol

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager(), selectedSport: Sport) {
        self.firebaseManager = firebaseManager
        self.selectedSport = selectedSport
    }

    private func fetchPlayers() {
        firebaseManager.fetchPlayers { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.players = data.filter { $0.sport == HomeViewModel.whichSport }
                    print(self.players.first?.name as Any)
                    self.view?.reloadCollectionView()
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
    }

    func viewDidLoad() {
        view?.setupNavBar()
        view?.registerCollectionView()
    }

    func numberOfItem(in section: Int) -> Int {
        players.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> PlayersCardCellVM {
        let playersCardCellVM = PlayersCardCellVM(player: players[indexPath.row])
        return playersCardCellVM
    }

    func addButtonTapped() {
        delegate?.navigateToAddPlayers(with: selectedSport)
    }
    
    func cellTapped(at indexPath: IndexPath) {
        delegate?.navigateToDetail(at: indexPath, with: selectedSport)
    }
    
    func updateCollectionData() {
        fetchPlayers()
    }
}
