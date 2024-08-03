//
//  MenuViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 2.08.2024.
//

import UIKit

class MenuViewController: UIViewController {

    var selectedSport: Sport?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }




    @IBAction func playersButtonClicked(_ sender: Any) {
        let vc = PlayersScreenVC()
        let viewModel = PlayersScreenVM(selectedSport: selectedSport!)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }


    @IBAction func createMatchClicked(_ sender: Any) {
        let vc = CreateMatchViewController()
        let createMatchViewModel = CreateMatchViewModel()
        vc.viewModel = createMatchViewModel
        navigationController?.pushViewController(vc, animated: true)
    }

}
