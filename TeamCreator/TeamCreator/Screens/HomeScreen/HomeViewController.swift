//
//  ViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 29.07.2024.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var soccerImageView: UIImageView!
    @IBOutlet weak var volleyballImageView: UIImageView!

    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

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
        //viewModel.soccerButtonTapped()
    }

    @objc func volleyballButtonTapped() {
        //viewModel.volleybolButtonTapped()
    }


}

extension HomeViewController: HomeViewModelDelegate {

}

