//
//  PlayersCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 31.07.2024.
//

import UIKit

final class PlayersCell: UITableViewCell {

    @IBOutlet private weak var playersImageView: UIImageView!
    @IBOutlet private weak var playersNameLabel: UILabel!
    @IBOutlet private weak var playersPositonLabel: UILabel!
    @IBOutlet private weak var playersSkillLabel: UILabel!
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
    
    
    func prepareCell(with model: PlayersCellVM) {
        playersNameLabel.text = model.playerName
        playersPositonLabel.text = model.playerPosition
        playersSkillLabel.text = model.playerSkill
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
