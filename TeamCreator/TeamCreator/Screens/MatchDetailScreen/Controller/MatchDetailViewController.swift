//
//  CreateMatchDetailViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import UIKit

final class MatchDetailViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet private weak var locationTimeLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var tempatureLabel: UILabel!
    @IBOutlet private weak var fenerbahceImageView: UIImageView!
    @IBOutlet private weak var galatasarayImageView: UIImageView!
    @IBOutlet private weak var weatherOuterView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: MatchDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
        configureImages()
        configureWeatherOuterView()
        print(Constant.firstTeam, viewModel.sumOfSkillTeamOne)
        print(Constant.secondTeam, viewModel.sumOfSkillTeamTwo)
    }

//MARK: Configure
    private func configureImages() {
        galatasarayImageView.isUserInteractionEnabled = true
        fenerbahceImageView.isUserInteractionEnabled = true
        galatasarayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(galatasarayTapped)))
        fenerbahceImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fenerbahceTapped)))
        startPulseAnimation(for: fenerbahceImageView)
        startPulseAnimation(for: galatasarayImageView)
    }

    private func configureWeatherOuterView() {
        weatherOuterView.layer.cornerRadius = 10
        weatherOuterView.layer.shadowColor = UIColor.black.cgColor
        weatherOuterView.layer.shadowOpacity = 0.5
        weatherOuterView.layer.shadowOffset = .zero
        weatherOuterView.layer.shadowRadius = 5
        weatherOuterView.backgroundColor = UIColor(hex: Constant.backgroundColor)
    }

    //MARK: - Animations
    private func startPulseAnimation(for imageView: UIImageView) {
        let pulseAnimation = CABasicAnimation(keyPath: Constant.animationKeyPath)
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        imageView.layer.add(pulseAnimation, forKey: Constant.animationKeyPathImage)
    }

    //MARK: - Actions
    @objc private func galatasarayTapped() {
        if HomeViewModel.whichSport == Constant.football {
            let vc = MatchDetailFootballViewController()
            let matchDetailTeamViewModel = MatchDetailFootballViewModel()
            vc.viewModel = matchDetailTeamViewModel
            matchDetailTeamViewModel.getTeam = viewModel.getSetTeam1
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = VolleyballViewController()
            let volleyballViewModel = VolleyballViewModel()
            vc.viewModel = volleyballViewModel
            volleyballViewModel.getTeam = viewModel.getSetTeam1
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc private func fenerbahceTapped() {
        if HomeViewModel.whichSport == Constant.football {
            let vc = MatchDetailFootballViewController()
            let matchDetailTeamViewModel = MatchDetailFootballViewModel()
            vc.viewModel = matchDetailTeamViewModel
            matchDetailTeamViewModel.getTeam = viewModel.getSetTeam2
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = VolleyballViewController()
            let volleyballViewModel = VolleyballViewModel()
            vc.viewModel = volleyballViewModel
            volleyballViewModel.getTeam = viewModel.getSetTeam2
            navigationController?.pushViewController(vc, animated: true)
        }
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

//MARK: - ViewModel Delegate
extension MatchDetailViewController: MatchDetailViewModelDelegate {
    func loadingIndicator() {
        activityIndicator.startAnimating()
    }

    func stopLoadingIndicator() {
        activityIndicator.stopAnimating()

    }

    func changeWeatherImage(_ imageName: String) {
        weatherImageView.image = UIImage(named: imageName)
    }

    func didFetchWeather() {
        locationTimeLabel.text = "\(viewModel.getCity) - \(viewModel.getTime)"
        weatherLabel.text = viewModel.getWeather.weather?.first?.main
        tempatureLabel.text = "\(viewModel.getWeather.main?.temp ?? 0)°C"
    }
}

//MARK: - Constant Extension
private extension MatchDetailViewController {
    enum Constant {
        static let firstTeam = "Team 1:"
        static let secondTeam = "Team 2:"
        static let backgroundColor = "E4F1FF"
        static let animationKeyPath = "transform.scale"
        static let animationKeyPathImage = "pulse"
        static let football = "Football"
    }
}
