//
//  PlayerDetailNameCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import UIKit

protocol EditableCellProtocol {
    func setEditing(isEditing: Bool)
}

final class PlayerDetailNameCell: UITableViewCell, EditableCellProtocol {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var playerDetailNameTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell(){
        view.layer.cornerRadius = 10
    }
    
    func prepareCell(with model: PlayerDetailNameCellVM) {
        playerDetailNameTextField.text = model.playerLabel
    }
    
    func setEditing(isEditing: Bool) {
        playerDetailNameTextField.isEnabled = isEditing
    }
}
