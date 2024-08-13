//
//  CreateMatchDetailViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import Foundation

//MARK: - Delegate
protocol MatchDetailViewModelDelegate: AnyObject {
    func didFetchWeather()
    func changeWeatherImage(_ imageName: String)
    func loadingIndicator()
    func stopLoadingIndicator()
}

//MARK: - Protocol
protocol MatchDetailViewModelProtocol {
    var delegate: MatchDetailViewModelDelegate? { get set }
    var getTime: String { get }
    var getCity: String { get }
    var getWeather: WeatherModel { get }
    var setSelectedPlayers: [Player] { get set }
    var getSetTeam1: [Player] { get set }
    var getSetTeam2: [Player] { get set }
    var sumOfSkillTeamOne: Int { get }
    var sumOfSkillTeamTwo: Int { get }

    func fetch()
}

//MARK: - ViewModel
final class MatchDetailViewModel {

    weak var delegate: MatchDetailViewModelDelegate?
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

    deinit {
        selectedPlayers.removeAll()
        team1.removeAll()
        team2.removeAll()
    }

    fileprivate func fetchWeather() {
        delegate?.loadingIndicator()
        guard let longitude, let latitude else { return }
        networkManager.fetch(url: "\(Constant.weatherBaseURL)\(latitude)\(Constant.weatherLongitude)\(longitude)\(Constant.weatherAPIKey)", method: .get, parameters: nil, headers: nil) { [weak self] (result: Result<WeatherModel, Error>) in
            guard let self else { return }
            switch result {
            case .success(let weather):
                self.weather = weather
                if ((weather.weather?.first?.main?.contains(Constant.weatherCloud)) == true) {
                    self.delegate?.changeWeatherImage(Constant.weatherCloudImage)
                }
                else if ((weather.weather?.first?.main?.contains(Constant.weatherThunder)) == true) {
                    self.delegate?.changeWeatherImage(Constant.weatherThunderImage)
                }
                else if ((weather.weather?.first?.main?.contains(Constant.weatherRain)) == true) {
                    self.delegate?.changeWeatherImage(Constant.weatherRainImage)
                }
                else if ((weather.weather?.first?.main?.contains(Constant.weatherClear)) == true) || ((weather.weather?.first?.main?.contains(Constant.weatherSun)) == true) {
                    self.delegate?.changeWeatherImage(Constant.weatherSunImage)
                }
                else if ((weather.weather?.first?.main?.contains(Constant.weatherSnow)) == true) {
                    self.delegate?.changeWeatherImage(Constant.weatherSnowImage)
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
extension MatchDetailViewModel: MatchDetailViewModelProtocol {
    var sumOfSkillTeamTwo: Int {
        var sum = 0
        team2.forEach { sum += $0.skillPoint ?? 0 }
        return sum
    }

    var sumOfSkillTeamOne: Int {
        var sum = 0
        team1.forEach { sum += $0.skillPoint ?? 0 }
        return sum
    }

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
            selectedPlayers
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

//MARK: - Constant Extension
private extension MatchDetailViewModel {
    enum Constant {
        static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?lat="
        static let weatherLongitude = "&lon="
        static let weatherAPIKey = "&appid=7322abaed58e1f99fa30adbc734b7ae7&units=metric"
        static let weatherCloud = "Cloud"
        static let weatherCloudImage = "cloud"
        static let weatherThunder = "Thunder"
        static let weatherThunderImage = "thunder"
        static let weatherRain = "Rainy"
        static let weatherRainImage = "rain"
        static let weatherClear = "Clear"
        static let weatherSun = "sunny"
        static let weatherSunImage = "sun"
        static let weatherSnow = "Snow"
        static let weatherSnowImage = "snow"
    }
}

