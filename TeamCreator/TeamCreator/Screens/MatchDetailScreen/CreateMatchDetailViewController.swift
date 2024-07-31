//
//  CreateMatchDetailViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import UIKit

class CreateMatchDetailViewController: UIViewController {
    @IBOutlet private weak var locationTimeLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var tempatureLabel: UILabel!

    var viewModel: CreateMatchDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
        configureLabel()
    }

    private func configureLabel() {

    }

}

extension CreateMatchDetailViewController: CreateMatchDetailViewModelDelegate {

    func changeWeatherImage(_ imageName: String) {
        weatherImageView.image = UIImage(named: imageName)
    }

    func didFetchWeather() {
        locationTimeLabel.text = "\(viewModel.getCity) - \(viewModel.getTime)"
        weatherLabel.text = viewModel.getWeather.weather?.first?.main
        tempatureLabel.text = "\(viewModel.getWeather.main?.temp ?? 0)°C"
    }

}
