//
//  CreateHomeViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import Foundation
import CoreLocation

//MARK: - Delegate
protocol CreateMatchViewModelDelegate: AnyObject {
    func didUpdateLocation()
    func reloadTableView()
    func loadingIndicator()
    func stopLoadingIndicator()
}
//MARK: - Protocol
protocol CreateMatchViewModelProtocol {
    var delegate: CreateMatchViewModelDelegate? { get set }
    var time: String { get }
    var getCity: String { get }
    var getLongitude: Double? { get }
    var getLatitude: Double? { get }
    var getPlayersCount: Int { get }
    var getPlayers: [Player] { get }
    var getSelectedPlayers: [Player] { get }
    var getTeam1: [Player] { get }
    var getTeam2: [Player] { get }

    func fetchPlayers()
    func addSelectedPlayer(indexPath: IndexPath)
    func setTeams()
}

final class CreateMatchViewModel: NSObject {

    weak var delegate: CreateMatchViewModelDelegate?
    private var networkManager: NetworkManagerProtocol?

    private var city: String?
    private let locationManager = CLLocationManager()
    private let firebaseManager: FirebaseManagerProtocol?
    private let geocoder = CLGeocoder()
    private var longitude: Double?
    private var latitude: Double?
    private var locationData: CLLocation?
    private var players = [Player]()
    private var selectedPlayers = [Player]()
    private var team1 = [Player]()
    private var team2 = [Player]()

    private let footballPositions = ["Goalkeeper", "Left Back", "Center Back", "Right Back", "Center Midfielder", "Right Winger", "Left Winger", "Center Forward"]
    private let volleyballPositions = ["Setter", "Outside Hitter", "Middle Blocker", "Opposite", "Libero", "Right Side Hitter"]

    // Football position limits
    let footballPositionLimits: [String: Int] = [
        "Goalkeeper": 1,
        "Left Back": 1,
        "Center Back": 2,
        "Right Back": 1,
        "Center Midfielder": 2,
        "Right Winger": 1,
        "Left Winger": 1,
        "Center Forward": 2
    ]

    // Volleyball position limits
    let volleyballPositionLimits: [String: Int] = [
        "Setter": 1,
        "Outside Hitter": 1,
        "Middle Blocker": 1,
        "Opposite": 1,
        "Libero": 1,
        "Right Side Hitter": 1
    ]

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager.shared) {
        self.firebaseManager = firebaseManager
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    deinit {
        locationManager.stopUpdatingLocation()
    }

//MARK: - Private Functions
    fileprivate func fetch() {
        delegate?.loadingIndicator()
        firebaseManager?.fetchPlayers { result in
            switch result {
            case .success(let data):
                self.players = data.filter { $0.sport == HomeViewModel.whichSport }
                self.delegate?.reloadTableView()
                self.delegate?.stopLoadingIndicator()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    fileprivate func splitIntoTeams(players: [Player], positions: [String], positionLimits: [String: Int]) -> ([Player], [Player]) {
        var team1 = [Player]()
        var team2 = [Player]()
        var team1Limits = positionLimits
        var team2Limits = positionLimits

        var positionGroups = [String: [Player]]()
        for position in positions {
            positionGroups[position] = players.filter { $0.position == position }
        }

        for position in positions {
            guard let groupedPlayers = positionGroups[position] else { continue }
            let sortedPlayers = groupedPlayers.sorted { ($0.skillPoint ?? 0) > ($1.skillPoint ?? 0) }

            for player in sortedPlayers {
                if let limit1 = team1Limits[player.position ?? ""] {
                    if limit1 > 0 {
                        team1.append(player)
                        team1Limits[player.position ?? ""] = limit1 - 1
                    } else if let limit2 = team2Limits[player.position ?? ""] {
                        if limit2 > 0 {
                            team2.append(player)
                            team2Limits[player.position ?? ""] = limit2 - 1
                        }
                    }
                }
            }
        }
        return (team1, team2)
    }

    fileprivate func setFootballTeams() {
        let teams = splitIntoTeams(players: players, positions: footballPositions, positionLimits: footballPositionLimits)
        team1 = teams.0
        team2 = teams.1
    }

    fileprivate func setVolleyballTeams() {
        let teams = splitIntoTeams(players: players, positions: volleyballPositions, positionLimits: volleyballPositionLimits)
        team1 = teams.0
        team2 = teams.1
    }

}

//MARK: - Protocol Extension
extension CreateMatchViewModel: CreateMatchViewModelProtocol {

    func setTeams() {
        if HomeViewModel.whichSport == "Volleyball" {
            setVolleyballTeams()
        } else {
            setFootballTeams()
        }
    }

    func addSelectedPlayer(indexPath: IndexPath) {
        if selectedPlayers.contains(where: { $0 == players[indexPath.row] }) {
            selectedPlayers.removeAll { $0 == players[indexPath.row] }
            return
        }
        selectedPlayers.append(players[indexPath.row])
    }

    func fetchPlayers() {
        fetch()
    }

//MARK: Getters
    var getTeam1: [Player] {
        team1
    }

    var getTeam2: [Player] {
        team2
    }

    var getSelectedPlayers: [Player] {
        selectedPlayers
    }

    var getPlayers: [Player] {
        players
    }

    var getPlayersCount: Int {
        players.count
    }

    var getLongitude: Double? {
        longitude
    }

    var getLatitude: Double? {
        latitude
    }

    var getCity: String {
        guard let city else { return "" }
        return city
    }

    var time: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

//MARK: - CLLocationManagerDelegate
extension CreateMatchViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationData = locations.first
        longitude = locationData?.coordinate.longitude
        latitude = locationData?.coordinate.latitude
        geocoder.reverseGeocodeLocation(locationData!) { (placemarks, error) in
            if let error {
                print("Error \(error)")
            }
            if let placemark = placemarks?.first {
                self.city = placemark.locality
            }
            self.delegate?.didUpdateLocation()
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed")
    }
}




