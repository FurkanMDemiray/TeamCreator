//
//  MatchDetailTeamsViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import UIKit

class MatchDetailTeamsViewController: UIViewController {

    @IBOutlet private weak var collectionVİew: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}

extension MatchDetailTeamsViewController: MatchDetailTeamsViewModelDelegate {

}

extension MatchDetailTeamsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchDetailTeamsCell.matchDetailTeamsCellId, for: indexPath) as! MatchDetailTeamsCell
        return cell
    }
}

extension MatchDetailTeamsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}


