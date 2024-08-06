//
//  MatchDetailTeamsViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import UIKit

class MatchDetailTeamsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: MatchDetailTeamsViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()

    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MatchDetailTeamsCell.matchDetailTeamsCellId, bundle: nil), forCellWithReuseIdentifier: MatchDetailTeamsCell.matchDetailTeamsCellId)
    }

}

extension MatchDetailTeamsViewController: MatchDetailTeamsViewModelDelegate {

}

extension MatchDetailTeamsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.team1.count + viewModel.team2.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchDetailTeamsCell.matchDetailTeamsCellId, for: indexPath) as! MatchDetailTeamsCell
        cell.configure(with: indexPath.row < viewModel.team1.count ? viewModel.team1[indexPath.row] : viewModel.team2[indexPath.row - viewModel.team1.count])
        return cell
    }
}

extension MatchDetailTeamsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension MatchDetailTeamsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }
}


