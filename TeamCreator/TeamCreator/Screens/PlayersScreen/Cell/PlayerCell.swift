//
//  PlayerCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 31.07.2024.
//

import UIKit

final class PlayerCell: UITableViewCell {

    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var playerPositonLabel: UILabel!
    @IBOutlet private weak var playerSkillLabel: UILabel!
    @IBOutlet private weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardView()
    }
    
    private func setupCardView() {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.label.cgColor
    }
    
    
    func prepareCell(with model: PlayerCellVM) {
        playerNameLabel.text = model.playerName
        playerPositonLabel.text = model.playerPosition
        //playerSkillLabel.text = model.playerSkill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = UIColor.white
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            contentView.backgroundColor = UIColor.white
        }
    }
    
    
}
