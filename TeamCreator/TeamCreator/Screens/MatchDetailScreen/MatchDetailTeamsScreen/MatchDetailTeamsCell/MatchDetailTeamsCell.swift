//
//  MatchDetailTeamsCell.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import UIKit

class MatchDetailTeamsCell: UICollectionViewCell {

    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var skillPointLabel: UILabel!
    @IBOutlet private weak var playerPositionLabel: UILabel!
    static let matchDetailTeamsCellId = "MatchDetailTeamsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
