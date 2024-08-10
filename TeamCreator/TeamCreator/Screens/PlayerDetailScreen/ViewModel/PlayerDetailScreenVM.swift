//
//  PlayerDetailScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import Foundation

//MARK: - Enum
enum CellType {
    case image(_ image: String?)
    case name(_ name: String?)
    case position(_ position: String?)
    case skill(_ skill: Int?)
}

//MARK: - Delegate
protocol PlayerDetailScreenVmDelegate: AnyObject {
    func playerDetailScreenDidDeletePlayer()
    func playerDetailScreenDidEditPlayer()
}

//MARK: - Protocol
protocol PlayerDetailScreenVMProtocol {
    var view: PlayerDetailScreenVCProtocol? { get set }
    var delegate: PlayerDetailScreenVmDelegate? { get set }
    func viewDidLoad()
    func deletePlayer()
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> CellVM
    func titleForHeader(section: Int) -> String
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func getEditingMode() -> Bool
    func changeEditingMode(_ isEditingMode: Bool)
}

//MARK: - Class
final class PlayerDetailScreenVM {
    
    //MARK: - Variables
    private var player: Player
    private var editedPlayer: Player?
    private var isEditingMode: Bool = false
    weak var view: PlayerDetailScreenVCProtocol?
    weak var delegate: PlayerDetailScreenVmDelegate?
    var cellTypes: [CellType] = []
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
    }
    
    private func updateCellTypes() {
        cellTypes.removeAll()
        cellTypes.append(.image(player.picture))
        cellTypes.append(.name(player.name))
        cellTypes.append(.position(player.position))
        cellTypes.append(.skill(player.skillPoint))
        view?.reloadTableView()
    }
}

extension PlayerDetailScreenVM: PlayerDetailScreenVMProtocol {
    
    //MARK: - Functions
    func viewDidLoad() {
        view?.setupNavBarButton()
        view?.registerTableView()
        updateCellTypes()
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
    
    func numberOfSections() -> Int {
        cellTypes.count
    }
    
    func numberOfRows(section: Int) -> Int {
        1
    }
    
    func cellForRow(at indexPath: IndexPath) -> CellVM {
        switch cellTypes[indexPath.section] {
        case .image:
            return PlayerDetailImageCellVM(image: player.picture)
        case .name:
            return PlayerDetailNameCellVM(name: player.name)
        case .position:
            return PlayerDetailPositionCellVM(position: player.position)
        case .skill:
            return PlayerDetailSkillCellVM(skill: player.skillPoint)
        }
    }
    
    func titleForHeader(section: Int) -> String {
        switch cellTypes[section] {
        case .image:
            return ""
        case .name:
            return "Name"
        case .position:
            return "Position"
        case .skill:
            return "Skill"
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        switch cellTypes[indexPath.section] {
        case .image:
            return 200
        case .name, .position, .skill:
            return 44
        }
    }
    
    func getEditingMode() -> Bool {
        isEditingMode
    }
    
    func changeEditingMode(_ isEditingMode: Bool) {
        self.isEditingMode = isEditingMode
    }
}
