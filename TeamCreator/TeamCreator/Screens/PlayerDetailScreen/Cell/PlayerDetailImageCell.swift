//
//  PlayerDetailImageCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import UIKit

final class PlayerDetailImageCell: UITableViewCell {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var playerDetailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell(){
        view.layer.cornerRadius = 10
    }
    
    func prepareCell(with model: PlayerDetailImageCellVM) {
        playerDetailImageView.loadImage(from: model.playerImage)
    }
}
