//
//  AddPlayerScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 1.08.2024.
//

import Foundation

//MARK: - Delegate Protocol
protocol AddPlayerScreenVMDelegate: AnyObject {
    func navigateBackToPlayers()
}

//MARK: - Protocol
protocol AddPlayerScreenVMProtocol {
    var view: AddPlayerScreenVCProtocol? { get set }
    var delegate: AddPlayerScreenVMDelegate? { get set }
    var selectedSport: Sport { get }
    func viewDidLoad()
    func numberOfRows() -> Int
    func titleForRow(row: Int) -> String
    func validatePlayerDetails(player: Player) -> ValidationResult
    func addPlayer(player: Player)
}

//MARK: - Class
final class AddPlayerScreenVM {
    
    //MARK: - Variables
    weak var view: AddPlayerScreenVCProtocol?
    weak var delegate: AddPlayerScreenVMDelegate?
    var selectedSport: Sport
    private var positions = [String]()
    private let sportPositions: [Sport: [String]] = [
        .football: FootballPosition.allCases.map { $0.rawValue },
        .volleyball: VolleyballPosition.allCases.map { $0.rawValue }
    ]
    let firebaseManager: FirebaseManagerProtocol

    //MARK: - Initialize 
    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager(), selectedSport: Sport) {
        self.firebaseManager = firebaseManager
        self.selectedSport = selectedSport
        setupPositions()
    }
    
    private func setupPositions() {
        positions = sportPositions[selectedSport] ?? []
        view?.reloadPickerView()
    }
    
}

extension AddPlayerScreenVM: AddPlayerScreenVMProtocol {
    
    //MARK: - Functions
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
    
    func validatePlayerDetails(player: Player) -> ValidationResult {
        guard let name = player.name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  else {
            return .failure(message: Constant.validateNameFail)
        }
        guard let position = player.position, !position.isEmpty else {
            return .failure(message: Constant.validatePositionFail)
        }
        guard let skill = player.skillPoint, skill > 0, skill <= 100 else {
            return .failure(message: Constant.validateSkillFail)
        }
        guard let imageString = player.picture, !imageString.isEmpty else {
            return .failure(message: Constant.validateImageFail)
        }
        return .success
    }

    func addPlayer(player: Player) {
        firebaseManager.addPlayer(player: player) { result in
            switch result {
            case .success:
                self.view?.clearFields()
                self.delegate?.navigateBackToPlayers()
            case .failure(let error):
                print("\(Constant.errorAddPlayer)\(error.localizedDescription)")
                self.view?.showError(message: Constant.failedMessage)
            }
        }
    }
}

//MARK: - Constants Extension
private extension AddPlayerScreenVM {
    enum Constant {
        static let validateNameFail = "Name cannot be empty."
        static let validatePositionFail = "Position cannot be empty."
        static let validateSkillFail = "Skill must be a valid number between 1 and 100."
        static let validateImageFail = "Please select an image."
        static let errorAddPlayer = "error adding players"
        static let failedMessage = "Failed to add player. Try Again."
    }
}
