//
//  PlayerDetailScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import Foundation

//MARK: - Enum
enum ValidationResult {
    case success
    case failure(message: String)
}

//MARK: - Delegate
protocol PlayerDetailScreenVmDelegate: AnyObject {
    func playerDetailScreenDidDeletePlayer()
    func playerDetailScreenDidEditPlayer()
}

//MARK: - Protocol
protocol PLayerDetailScreenVMProtocol {
    var view: PlayerDetailScreenVCProtocol? { get set }
    var delegate: PlayerDetailScreenVmDelegate? { get set }
    func viewDidLoad()
    func deletePlayer()
    func discardEditPlayer() -> Player
    func validatePlayerDetails(name: String?, position: String?, skill: String?, image: String?) -> ValidationResult
    func updatePlayer(name: String, position: String, skill: Int, image: String)
    func numberOfRows() -> Int
    func titleForRow(row: Int) -> String
}

//MARK: - Class
final class PlayerDetailScreenVM {
    
    //MARK: - Variables
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
    
    //MARK: - Initialize
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
    //MARK: - Functions
    func viewDidLoad() {
        view?.setupNavBarButton()
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
    
    func discardEditPlayer() -> Player {
        player
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
    
    func validatePlayerDetails(name: String?, position: String?, skill: String?, image: String?) -> ValidationResult {
        guard let imageString = image, !imageString.isEmpty else {
            return .failure(message: "Please select an image.")
        }
        guard let name = name, !name.isEmpty else {
            return .failure(message: "Name cannot be empty.")
        }
        guard let position = position, !position.isEmpty else {
            return .failure(message: "Position cannot be empty.")
        }
        guard let skillText = skill, !skillText.isEmpty, let skill = Int(skillText), skill > 0, skill <= 100 else {
            return .failure(message: "Skill must be a valid number between 1 and 100.")
        }
        return .success
    }
    
    func updatePlayer(name: String, position: String, skill: Int, image: String) {
        player.name = name
        player.position = position
        player.skillPoint = skill
        player.picture = image
        
        firebaseManager.updatePlayer(player: player) { result in
            switch result {
            case .success():
                self.delegate?.playerDetailScreenDidEditPlayer()
            case .failure(let error):
                print("Failed to update player: \(error.localizedDescription)")
            }
        }
    }
}
