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
}

protocol CreateMatchViewModelProtocol {
    var delegate: CreateMatchViewModelDelegate? { get set }
    var time: String { get }
    var getCity: String { get }
}

final class CreateMatchViewModel: NSObject {

    weak var delegate: CreateMatchViewModelDelegate?
    var networkManager: NetworkManagerProtocol?

    private var city: String?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
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

extension CreateMatchViewModel: CreateMatchViewModelProtocol {
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

extension CreateMatchViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationData = locations.first
        geocoder.reverseGeocodeLocation(locationData!) { (placemarks, error) in
            if let error {
                print("Error \(error)")
            }
            if let placemark = placemarks?.first {
                print("City: \(placemark.locality!)")
                self.city = placemark.locality
            }
        }
        delegate?.didUpdateLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed")
    }
}




