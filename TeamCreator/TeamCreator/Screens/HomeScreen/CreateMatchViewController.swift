//
//  CreateMatchViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import UIKit


final class CreateMatchViewController: UIViewController {

    @IBOutlet weak var locationTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: CreateHomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PlayerCell.id, bundle: nil), forCellReuseIdentifier: PlayerCell.id)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }

    @IBAction func continueButtonClicked(_ sender: Any) {

    }
}

extension CreateMatchViewController: CreateHomeViewModelDelegate {
    func didUpdateLocation() {
        locationTimeLabel.text = "\(viewModel.getCity) - \(viewModel.time)"
    }
}

extension CreateMatchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.id, for: indexPath) as! PlayerCell
        cell.configure(with: "test")
        return cell
    }
}


