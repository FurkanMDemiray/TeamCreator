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
}

final class PlayerDetailScreenVM {
    private let player: Player
    weak var view: PlayerDetailScreenVCProtocol?
    weak var delegate: PlayerDetailScreenVmDelegate?
    let firebaseManager: FirebaseManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager(), player: Player) {
        self.firebaseManager = firebaseManager
        self.player = player
    }
}

extension PlayerDetailScreenVM: PLayerDetailScreenVMProtocol {
    
    
    func viewDidLoad() {
        view?.configureLabels(name: player.name ?? "", position: player.position ?? "", skill: String(describing: player.skillPoint ?? 0))
        view?.configureImage(image: player.picture ?? "")
    }
    
    
    func deletePlayer() {
        firebaseManager.deletePlayer(player: player) { result in
            switch result {
            case .success:
                print("\(String(describing: self.player.name)) deleted")
                self.delegate?.playerDetailScreenDidDeletePlayer()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
