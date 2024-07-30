//
//  CreateMatchViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import UIKit


final class CreateMatchViewController: UIViewController {
    @IBOutlet weak var locationTimeLabel: UILabel!

    var viewModel: CreateHomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CreateMatchViewController: CreateHomeViewModelDelegate {
    func didUpdateLocation() {
        locationTimeLabel.text = " \(viewModel.longitude)  \(viewModel.latitude) Time: \(viewModel.time)"
    }
}


