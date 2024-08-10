//
//  PlayerDetailPositionCell.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 9.08.2024.
//

import UIKit

final class PlayerDetailPositionCell: UITableViewCell, EditableCellProtocol {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var playerDetailPositonTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell(){
        view.layer.cornerRadius = 10
    }
    
    func prepareCell(with model: PlayerDetailPositionCellVM) {
        playerDetailPositonTextField.text = model.playerPosition
    }
    
    func setEditing(isEditing: Bool) {
        playerDetailPositonTextField.isEnabled = isEditing
    }
    
}
