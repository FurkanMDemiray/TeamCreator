//
//  PlayerDetailSkillCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import UIKit

final class PlayerDetailSkillCell: UITableViewCell, EditableCellProtocol{

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var playerDetailSkillTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell(){
        view.layer.cornerRadius = 10
    }
    
    func prepareCell(with model: PlayerDetailSkillCellVM) {
        playerDetailSkillTextField.text = model.playerSkill
    }
    
    func setEditing(isEditing: Bool) {
        playerDetailSkillTextField.isEnabled = isEditing
    }
}
