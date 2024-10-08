//
//  MatchDetailTeamsCell.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import UIKit

final class MatchDetailTeamsCell: UICollectionViewCell {

    static let matchDetailTeamsCellId = "MatchDetailTeamsCell"

    //MARK: - IBOutlets
    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var skillPointLabel: UILabel!
    @IBOutlet private weak var playerPositionLabel: UILabel!
    @IBOutlet private weak var outerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageView()
    }

    func configure(with player: Player) {
        playerNameLabel.text = player.name
        skillPointLabel.text = "\(player.skillPoint ?? 0)"
        playerPositionLabel.text = player.position
        playerImageView.loadImage(from: player.picture)
        configureOuterView()
    }

    private func configureImageView() {
        playerImageView.layer.cornerRadius = playerImageView.frame.size.width / 2
        playerImageView.clipsToBounds = true
    }

    private func configureOuterView() {
        if playerNameLabel.text == "" {
            return
        } else {
            outerView.layer.cornerRadius = 10
            outerView.layer.shadowColor = UIColor.black.cgColor
            outerView.layer.shadowOffset = CGSize(width: 0, height: 1)
            outerView.layer.shadowOpacity = 0.5
            outerView.layer.shadowRadius = 2
            outerView.backgroundColor = UIColor(hex: "C7C8CC")
        }

    }

}
