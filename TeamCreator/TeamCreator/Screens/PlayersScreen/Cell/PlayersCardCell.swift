//
//  PlayersCardCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import UIKit

final class PlayersCardCell: UICollectionViewCell {

    @IBOutlet private weak var cardImage: UIImageView!
    @IBOutlet private weak var cardRatingLabel: UILabel!
    @IBOutlet private weak var cardPlayerImage: UIImageView!
    @IBOutlet private weak var cardNameLabel: UILabel!
    @IBOutlet private weak var cardPositionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCard()
    }
    
    private func setupCard() {
        cardNameLabel.adjustsFontSizeToFitWidth = true
        cardNameLabel.minimumScaleFactor = 0.5
    }
    
    func prepareCell(with model: PlayersCardCellVM) {
        cardRatingLabel.text = model.playerRating
        cardNameLabel.text = model.playerName
        cardPositionLabel.text = model.playerPosition
        encodeImage(model: model)
        cardImage.image = UIImage(named: model.cardImage)
    }
    
    private func encodeImage(model: PlayersCardCellVM) {
        let imageData = Data(base64Encoded: model.playerImage ?? "")
        let image = UIImage(data: imageData ?? Data())
        cardPlayerImage.image = image
    }

}
