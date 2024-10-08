//
//  MatchDetailTeamsViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import UIKit

final class MatchDetailTeamsViewController: UIViewController {

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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }

}

extension MatchDetailTeamsViewController: MatchDetailTeamsViewModelDelegate { }

// MARK: - CollectionView
extension MatchDetailTeamsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.team1.count + viewModel.team2.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchDetailTeamsCell.matchDetailTeamsCellId, for: indexPath) as! MatchDetailTeamsCell
        if indexPath.row % 2 == 0 {
            let index = indexPath.row / 2
            if index < viewModel.team1.count {
                cell.configure(with: viewModel.team1[index])
            }
        } else {
            let index = indexPath.row / 2
            if index < viewModel.team2.count {
                cell.configure(with: viewModel.team2[index])
            }
        }
        return cell
    }
}

extension MatchDetailTeamsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
