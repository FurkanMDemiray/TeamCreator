//
//  PlayersScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 30.07.2024.
//

import UIKit

protocol PlayersScreenVCProtocol: AnyObject {
    func setupNavBar()
    func registerTableView()
    func reloadTableView()
}

final class PlayersScreenVC: UIViewController {
    
    private let viewModel = PlayersScreenVM()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension PlayersScreenVC: PlayersScreenVCProtocol {
    func setupNavBar() {
        let title = String(describing: Players.self)
        navigationItem.title = title
        let addPlayerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = addPlayerButton
    }
    
    func registerTableView() {
        let playerCellName = String(describing: PlayersCell.self)
        let playerCellNib = UINib(nibName: playerCellName, bundle: nil)
        tableView.register(playerCellNib, forCellReuseIdentifier: playerCellName)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension PlayersScreenVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayersCell.self)) as? PlayersCell {
            cell.prepareCell(with: viewModel.cellForRow(at: indexPath))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.viewModel.deletePlayer(at: indexPath)
            }))
            present(alert, animated: true)
        }
    }
}

extension PlayersScreenVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
