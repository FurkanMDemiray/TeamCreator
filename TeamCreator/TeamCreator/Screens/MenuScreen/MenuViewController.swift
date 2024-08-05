//
//  MenuViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 2.08.2024.
//

import UIKit

class MenuViewController: UIViewController {

    var selectedSport: Sport?
    @IBOutlet private weak var playersView: UIView!
    @IBOutlet private weak var createMatchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    }
    
    
    private func setupTapGesture() {
        let playersTapGesture = UITapGestureRecognizer(target: self, action: #selector(playersViewTapped))
        playersView.addGestureRecognizer(playersTapGesture)
        let createMatchTapGesture = UITapGestureRecognizer(target: self, action: #selector(createMathcViewTapped))
        createMatchView.addGestureRecognizer(createMatchTapGesture)
    }

    @objc private func playersViewTapped() {
        let vc = PlayersScreenVC()
        let viewModel = PlayersScreenVM(selectedSport: selectedSport!)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func createMathcViewTapped() {
        let vc = CreateMatchViewController()
        let createMatchViewModel = CreateMatchViewModel()
        vc.viewModel = createMatchViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
