//
//  CreateHomeViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import Foundation
import CoreLocation

protocol CreateMatchViewModelDelegate: AnyObject {
    func didUpdateLocation()
    func reloadTableView()
}

protocol CreateMatchViewModelProtocol {
    var delegate: CreateMatchViewModelDelegate? { get set }
    var time: String { get }
    var getCity: String { get }
    var getLongitude: Double? { get }
    var getLatitude: Double? { get }
    var getPlayersCount: Int { get }
    var getPlayers: [Player] { get }
    var getSelectedPlayers: [Player] { get }

    func fetchPlayers()
    func addSelectedPlayer(indexPath: IndexPath)
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

    fileprivate func fetch() {
        firebaseManager?.fetchPlayers { result in
            switch result {
            case .success(let data):
                self.players = data.filter { $0.sport == HomeViewModel.whichSport }
                self.delegate?.reloadTableView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension CreateMatchViewModel: CreateMatchViewModelProtocol {

    func addSelectedPlayer(indexPath: IndexPath) {
        if selectedPlayers.contains(where: { $0 == players[indexPath.row] }) {
            selectedPlayers.removeAll { $0 == players[indexPath.row] }
            selectedPlayers.forEach { print("----", $0.name!) }
            return
        }
        selectedPlayers.append(players[indexPath.row])
        selectedPlayers.forEach { print("----", $0.name!) }
    }

    func fetchPlayers() {
        fetch()
    }

//MARK: Getters
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




