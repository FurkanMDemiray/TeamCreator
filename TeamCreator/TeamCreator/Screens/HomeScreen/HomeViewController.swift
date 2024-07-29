//
//  ViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 29.07.2024.
//

import UIKit

final class HomeViewController: UIViewController {

    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension HomeViewController: HomeViewModelDelegate {

}

