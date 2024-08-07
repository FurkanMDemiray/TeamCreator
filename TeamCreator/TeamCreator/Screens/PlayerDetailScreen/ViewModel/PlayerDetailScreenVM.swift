//
//  PlayerDetailScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import Foundation

protocol PlayerDetailScreenVmDelegate: AnyObject {
    func playerDetailScreenDidDeletePlayer()
}

protocol PLayerDetailScreenVMProtocol {
    var view: PlayerDetailScreenVCProtocol? { get set }
    var delegate: PlayerDetailScreenVmDelegate? { get set }
    func viewDidLoad()
    func deletePlayer()
    func updatePlayer(name: String, position: String, skill: Int)
    func numberOfRows() -> Int
    func titleForRow(row: Int) -> String
}

final class PlayerDetailScreenVM {
    private var player: Player
    weak var view: PlayerDetailScreenVCProtocol?
    weak var delegate: PlayerDetailScreenVmDelegate?
    var selectedSport: Sport
    private var positions = [String]()
    private let sportPositions: [Sport: [String]] = [
        .football: FootballPosition.allCases.map { $0.rawValue },
        .volleyball: VolleyballPosition.allCases.map { $0.rawValue }
    ]
    let firebaseManager: FirebaseManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager(), player: Player, selectedSport: Sport ) {
        self.firebaseManager = firebaseManager
        self.player = player
        self.selectedSport = selectedSport
        setupPositions()
    }
    
    private func setupPositions() {
        positions = sportPositions[selectedSport] ?? []
        view?.reloadPickerView()
    }
}

extension PlayerDetailScreenVM: PLayerDetailScreenVMProtocol {
    
    func viewDidLoad() {
        view?.setupEditButton()
        view?.configureLabels(name: player.name ?? "", position: player.position ?? "", skill: String(describing: player.skillPoint ?? 0))
        view?.configureImage(image: player.picture ?? "")
        view?.setupPickerView()
        view?.setupToolBar()
    }
    
    func numberOfRows() -> Int {
        positions.count
    }
    
    func titleForRow(row: Int) -> String {
        positions[row]
    }
    
    
    func deletePlayer() {
        firebaseManager.deletePlayer(player: player) { result in
            switch result {
            case .success:
                self.delegate?.playerDetailScreenDidDeletePlayer()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updatePlayer(name: String, position: String, skill: Int) {
        player.name = name
        player.position = position
        player.skillPoint = skill
        //update user firebase manager
        print("updated player is : \(player)")
    }
}
