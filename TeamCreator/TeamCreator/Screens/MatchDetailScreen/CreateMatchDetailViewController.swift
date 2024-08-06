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
    @IBOutlet private weak var fenerbahceImageView: UIImageView!
    @IBOutlet private weak var galatasarayImageView: UIImageView!

    var viewModel: CreateMatchDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
        configureImages()
        //print("\(viewModel.setSelectedPlayers.forEach { print($0.name!) })")
    }

    private func configureImages() {
        galatasarayImageView.isUserInteractionEnabled = true
        fenerbahceImageView.isUserInteractionEnabled = true
        galatasarayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(galatasarayTapped)))
        fenerbahceImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fenerbahceTapped)))
        startPulseAnimation(for: fenerbahceImageView)
        startPulseAnimation(for: galatasarayImageView)
    }

    //MARK: - Animations
    private func startPulseAnimation(for imageView: UIImageView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        imageView.layer.add(pulseAnimation, forKey: "pulse")
    }

    //MARK: - Actions
    @objc private func fenerbahceTapped() {
        let vc = MatchDetailTeamViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func galatasarayTapped() {
        let vc = MatchDetailTeamViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func teamsButtonClicked(_ sender: Any) {
        let vc = MatchDetailTeamsViewController()
        let matchDetailTeamsViewModel = MatchDetailTeamsViewModel()
        vc.viewModel = matchDetailTeamsViewModel
        vc.viewModel.team1 = viewModel.getSetTeam1
        vc.viewModel.team2 = viewModel.getSetTeam2
        navigationController?.pushViewController(vc, animated: true)
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
