//
//  CreateMatchDetailViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import UIKit

class CreateMatchDetailViewController: UIViewController {
    @IBOutlet weak var locationTimeLabel: UILabel!

    var viewModel: CreateMatchDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
        configureLabel()
    }

    private func configureLabel() {
        locationTimeLabel.text = "\(viewModel.getCity) - \(viewModel.getTime)"
    }

}

extension CreateMatchDetailViewController: CreateMatchDetailViewModelDelegate {

}
