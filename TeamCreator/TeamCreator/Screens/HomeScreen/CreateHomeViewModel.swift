//
//  CreateHomeViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import Foundation
import CoreLocation

protocol CreateHomeViewModelDelegate: AnyObject {
    func didUpdateLocation()
}

protocol CreateHomeViewModelProtocol {
    var delegate: CreateHomeViewModelDelegate? { get set }
    var longitude: Double { get }
    var latitude: Double { get }
    var time: String { get }

}

final class CreateHomeViewModel: NSObject {

    weak var delegate: CreateHomeViewModelDelegate?
    var networkManager: NetworkManagerProtocol?

    private let locationManager = CLLocationManager()
    var locationData: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    deinit {
        locationManager.stopUpdatingLocation()
    }

}

extension CreateHomeViewModel: CreateHomeViewModelProtocol {
    var longitude: Double {
        locationData?.coordinate.longitude ?? 0
    }

    var latitude: Double {
        locationData?.coordinate.latitude ?? 0
    }

    var time: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

extension CreateHomeViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationData = locations.first
        delegate?.didUpdateLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed")
    }
}




