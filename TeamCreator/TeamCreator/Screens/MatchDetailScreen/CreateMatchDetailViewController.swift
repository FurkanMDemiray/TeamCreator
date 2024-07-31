//
//  CreateMatchDetailViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import UIKit

class CreateMatchDetailViewController: UIViewController {

    var viewModel: CreateMatchDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

extension CreateMatchDetailViewController: CreateMatchDetailViewModelDelegate {

}