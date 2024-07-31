//
//  CreateMatchDetailViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import Foundation

protocol CreateMatchDetailViewModelDelegate: AnyObject {
    func didFetchWeather()
    func changeWeatherImage(_ imageName: String)
}

protocol CreateMatchDetailViewModelProtocol {
    var delegate: CreateMatchDetailViewModelDelegate? { get set }
    var getTime: String { get }
    var getCity: String { get }
    var getWeather: WeatherModel { get }

    func fetch()
}

final class CreateMatchDetailViewModel {

    weak var delegate: CreateMatchDetailViewModelDelegate?
    var networkManager: NetworkManagerProtocol
    var longitude: Double?
    var latitude: Double?
    var time: String?
    var city: String?
    var weather: WeatherModel?

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    fileprivate func fetchWeather() {
        guard let longitude, let latitude else { return }
        networkManager.fetch(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=7322abaed58e1f99fa30adbc734b7ae7&units=metric", method: .get, parameters: nil, headers: nil) { [weak self] (result: Result<WeatherModel, Error>) in
            guard let self else { return }
            switch result {
            case .success(let weather):
                self.weather = weather
                if ((weather.weather?.first?.main?.contains("cloud")) != nil) {
                    self.delegate?.changeWeatherImage("cloudy")
                }
                else if ((weather.weather?.first?.main?.contains("thunder")) != nil) {
                    self.delegate?.changeWeatherImage("rainThunder")
                }
                else if ((weather.weather?.first?.main?.contains("rainy")) != nil) {
                    self.delegate?.changeWeatherImage("rainy")
                }
                else if ((weather.weather?.first?.main?.contains("clear")) != nil) || ((weather.weather?.first?.main?.contains("sunny")) != nil) {
                    self.delegate?.changeWeatherImage("sunny")
                }
                else if ((weather.weather?.first?.main?.contains("snow")) != nil) {
                    self.delegate?.changeWeatherImage("snowy")
                }

                delegate?.didFetchWeather()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension CreateMatchDetailViewModel: CreateMatchDetailViewModelProtocol {
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


