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

    var viewModel: CreateMatchViewModelProtocol! {
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
        tableView.register(UINib(nibName: CreateMatchCell.id, bundle: nil), forCellReuseIdentifier: CreateMatchCell.id)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        let vc = CreateMatchDetailViewController()
        let createMatchDetialViewModel = CreateMatchDetailViewModel()
        vc.viewModel = createMatchDetialViewModel
        createMatchDetialViewModel.longitude = viewModel.getLongitude
        createMatchDetialViewModel.latitude = viewModel.getLatitude
        createMatchDetialViewModel.time = viewModel.time
        createMatchDetialViewModel.city = viewModel.getCity
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CreateMatchViewController: CreateMatchViewModelDelegate {
    func didUpdateLocation() {
        guard let viewModel else { return }
        locationTimeLabel.text = "\(viewModel.getCity) - \(viewModel.time)"
    }
}

extension CreateMatchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateMatchCell.id, for: indexPath) as! CreateMatchCell
        cell.configure(with: "test")
        return cell
    }
}


