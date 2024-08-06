//
//  CreateMatchDetailViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import Foundation

//MARK: - Delegate
protocol CreateMatchDetailViewModelDelegate: AnyObject {
    func didFetchWeather()
    func changeWeatherImage(_ imageName: String)
    func loadingIndicator()
    func stopLoadingIndicator()
}

//MARK: - Protocol
protocol CreateMatchDetailViewModelProtocol {
    var delegate: CreateMatchDetailViewModelDelegate? { get set }
    var getTime: String { get }
    var getCity: String { get }
    var getWeather: WeatherModel { get }
    var setSelectedPlayers: [Player] { get set }
    var getSetTeam1: [Player] { get set }
    var getSetTeam2: [Player] { get set }

    func fetch()
}

//MARK: - ViewModel
final class CreateMatchDetailViewModel {

    weak var delegate: CreateMatchDetailViewModelDelegate?
    private var networkManager: NetworkManagerProtocol
    private var selectedPlayers = [Player]()
    private var team1 = [Player]()
    private var team2 = [Player]()
    var longitude: Double?
    var latitude: Double?
    var time: String?
    var city: String?
    var weather: WeatherModel?

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    fileprivate func fetchWeather() {
        delegate?.loadingIndicator()
        guard let longitude, let latitude else { return }
        networkManager.fetch(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=7322abaed58e1f99fa30adbc734b7ae7&units=metric", method: .get, parameters: nil, headers: nil) { [weak self] (result: Result<WeatherModel, Error>) in
            guard let self else { return }
            switch result {
            case .success(let weather):
                self.weather = weather
                if ((weather.weather?.first?.main?.contains("Cloud")) == true) {
                    self.delegate?.changeWeatherImage("cloud")
                }
                else if ((weather.weather?.first?.main?.contains("Thunder")) == true) {
                    self.delegate?.changeWeatherImage("thunder")
                }
                else if ((weather.weather?.first?.main?.contains("Rainy")) == true) {
                    self.delegate?.changeWeatherImage("rain")
                }
                else if ((weather.weather?.first?.main?.contains("Clear")) == true) || ((weather.weather?.first?.main?.contains("sunny")) == true) {
                    self.delegate?.changeWeatherImage("sun")
                }
                else if ((weather.weather?.first?.main?.contains("Snow")) == true) {
                    self.delegate?.changeWeatherImage("snow")
                }
                delegate?.didFetchWeather()
                delegate?.stopLoadingIndicator()
            case .failure(let error):
                print(error)
            }
        }
    }

}

//MARK: - Protocol Extension
extension CreateMatchDetailViewModel: CreateMatchDetailViewModelProtocol {
    var getSetTeam1: [Player] {
        get {
            team1
        }
        set {
            team1 = newValue
        }
    }

    var getSetTeam2: [Player] {
        get {
            team2
        }
        set {
            team2 = newValue
        }
    }

    var setSelectedPlayers: [Player] {
        get {
            return selectedPlayers
        }
        set {
            selectedPlayers = newValue
        }
    }

    var getWeather: WeatherModel {
        guard let weather else { return WeatherModel(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil) }
        return weather
    }

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


