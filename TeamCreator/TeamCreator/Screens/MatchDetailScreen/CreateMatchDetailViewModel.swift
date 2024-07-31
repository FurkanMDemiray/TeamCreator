//
//  CreateMatchDetailViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import Foundation

protocol CreateMatchDetailViewModelDelegate: AnyObject {

}

protocol CreateMatchDetailViewModelProtocol {
    var delegate: CreateMatchDetailViewModelDelegate? { get set }
    var getTime: String { get }
    var getCity: String { get }

    func fetch()
}

final class CreateMatchDetailViewModel {

    weak var delegate: CreateMatchDetailViewModelDelegate?
    var networkManager: NetworkManagerProtocol
    var longitude: Double?
    var latitude: Double?
    var time: String?
    var city: String?

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    fileprivate func fetchWeather() {
        guard let longitude, let latitude else { return }
        networkManager.fetch(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=7322abaed58e1f99fa30adbc734b7ae7&units=metric", method: .get, parameters: nil, headers: nil) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success(let weather):
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension CreateMatchDetailViewModel: CreateMatchDetailViewModelProtocol {
    var getCity: String {
        guard let city else { return "" }
        return city
    }

    var getTime: String {
        guard let time else { return "" }
        return time
    }

    func fetch() {
        fetchWeather()
    }
}


