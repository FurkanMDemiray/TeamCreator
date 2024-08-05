//
//  PlayersScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 30.07.2024.
//

import UIKit

protocol PlayersScreenVCProtocol: AnyObject {
    func setupNavBar()
    func registerCollectionView()
    func reloadCollectionView()
}

final class PlayersScreenVC: UIViewController {

    var viewModel: PlayersScreenVMProtocol! {
        didSet {
            viewModel.view = self
            viewModel.delegate = self
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}

extension PlayersScreenVC: PlayersScreenVCProtocol {
    func setupNavBar() {
        let title = String(describing: Player.self)
        navigationItem.title = title
        let addPlayerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addPlayerButton
    }

    @objc private func addButtonTapped() {
        viewModel.addButtonTapped()
    }
    
    func registerCollectionView() {
        let playerCardCell = String(describing: PlayersCardCell.self)
        let playerCellNib = UINib(nibName: playerCardCell, bundle: nil)
        collectionView.register(playerCellNib, forCellWithReuseIdentifier: playerCardCell)
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension PlayersScreenVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItem(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlayersCardCell.self), for: indexPath) as? PlayersCardCell {
            cell.prepareCell(with: viewModel.cellForItem(at: indexPath))
            return cell
        }
        return UICollectionViewCell()
    }
}

extension PlayersScreenVC: UICollectionViewDelegate {
    
}

extension PlayersScreenVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewWidth = collectionView.frame.size.width - padding
        let cellWidth = collectionViewWidth / 2
        let cellHeight = cellWidth * (348/224)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension PlayersScreenVC: PlayersScreenVMDelegate {
    func navigateToAddPlayers(with selectedSport: Sport) {
        let addPlayerVC = AddPlayerScreenVC()
        let addPlayerVM = AddPlayerScreenVM(selectedSport: selectedSport)
        addPlayerVC.viewModel = addPlayerVM
        navigationController?.pushViewController(addPlayerVC, animated: true)
    }
}
