//
//  PlayersCardCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import UIKit

final class PlayersCardCell: UICollectionViewCell {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardRatingLabel: UILabel!
    @IBOutlet weak var cardPlayerImage: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardPositionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupCard() {
        
    }
    
    func prepareCell(with model: PlayersCardCellVM) {
        cardRatingLabel.text = model.playerRating
        cardNameLabel.text = model.playerName
        cardPositionLabel.text = model.playerPosition
        encodeImage(model: model)
    }
    
    private func encodeImage(model: PlayersCardCellVM) {
        let imageData = Data(base64Encoded: model.playerImage ?? "")
        let image = UIImage(data: imageData ?? Data())
        cardPlayerImage.image = image
    }

}
