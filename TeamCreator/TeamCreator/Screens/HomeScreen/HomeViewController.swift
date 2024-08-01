//
//  HomeViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import UIKit

class HomeViewController: UIViewController {

    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    @IBOutlet weak var soccerImageView: UIImageView!
    @IBOutlet weak var volleyballImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImages()
    }

    private func configureImages() {
        soccerImageView.isUserInteractionEnabled = true
        let gestureRecognizerSoccer = UITapGestureRecognizer(target: self, action: #selector(soccerButtonTapped))
        soccerImageView.addGestureRecognizer(gestureRecognizerSoccer)
        soccerImageView.layer.cornerRadius = 10
        soccerImageView.layer.shadowColor = UIColor.black.cgColor
        soccerImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        soccerImageView.layer.shadowRadius = 5

        let gestureRecognizerVolleyball = UITapGestureRecognizer(target: self, action: #selector(volleyballButtonTapped))
        volleyballImageView.addGestureRecognizer(gestureRecognizerVolleyball)
        volleyballImageView.isUserInteractionEnabled = true
        volleyballImageView.layer.cornerRadius = 10
        volleyballImageView.layer.shadowColor = UIColor.black.cgColor
        volleyballImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        volleyballImageView.layer.shadowRadius = 5
    }

    @objc func soccerButtonTapped() {
        let vc = CreateMatchViewController()
        let createMatchViewModel = CreateMatchViewModel()
        vc.viewModel = createMatchViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func volleyballButtonTapped() {
        //viewModel.volleybolButtonTapped()
    }


}

extension HomeViewController: HomeViewModelDelegate {

}
