//
//  CreateMatchViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import UIKit

final class CreateMatchViewController: UIViewController {

    @IBOutlet private weak var locationTimeLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: CreateMatchViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

//MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPlayers()
        viewModel.refreshSelectedPlayers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CreateMatchCell.createMatchCellId, bundle: nil), forCellReuseIdentifier: CreateMatchCell.createMatchCellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }

//MARK: - Actions
    @IBAction func continueButtonClicked(_ sender: Any) {
        viewModel.setTeams()
        let createMatchDetailViewController = CreateMatchDetailViewController()
        let createMatchDetailViewModel = CreateMatchDetailViewModel()
        createMatchDetailViewController.viewModel = createMatchDetailViewModel

        createMatchDetailViewModel.longitude = viewModel.getLongitude
        createMatchDetailViewModel.latitude = viewModel.getLatitude
        createMatchDetailViewModel.time = viewModel.time
        createMatchDetailViewModel.city = viewModel.getCity
        createMatchDetailViewModel.setSelectedPlayers = viewModel.getSelectedPlayers
        createMatchDetailViewModel.getSetTeam1 = viewModel.getTeam1
        createMatchDetailViewModel.getSetTeam2 = viewModel.getTeam2
        navigationController?.pushViewController(createMatchDetailViewController, animated: true)
    }
}

//MARK: - ViewModel Delegate
extension CreateMatchViewController: CreateMatchViewModelDelegate {
    func loadingIndicator() {
        activityIndicator.startAnimating()
    }

    func stopLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func didUpdateLocation() {
        guard let viewModel else { return }
        locationTimeLabel.text = "\(viewModel.getCity) - \(viewModel.time)"
    }
}

//MARK: - TableView Delegate & DataSource
extension CreateMatchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPlayersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateMatchCell.createMatchCellId, for: indexPath) as! CreateMatchCell
        let player = viewModel.getPlayersTmp[indexPath.row]
        let isChecked = viewModel.getSelectedPlayers.contains(player)
        cell.configure(with: player, isChecked: isChecked)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is CreateMatchCell {
            viewModel.addSelectedPlayer(indexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .right)
        }
    }
}

