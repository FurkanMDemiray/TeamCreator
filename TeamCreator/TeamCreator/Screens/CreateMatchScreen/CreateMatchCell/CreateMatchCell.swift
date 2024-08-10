//
//  PlayerCell.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import UIKit

final class CreateMatchCell: UITableViewCell {

    static let createMatchCellId = "CreateMatchCell"
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var skillPointLabel: UILabel!

    private var isChecked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }

    func configure(with player: Player, isChecked: Bool) {
        playerNameLabel.text = player.name
        positionLabel.text = player.position
        skillPointLabel.text = "\(player.skillPoint ?? 0)"
        self.isChecked = isChecked
        let imageName = isChecked ? "checkmark.square" : "square"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func configureButton() {
        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    func toggleCheckButton() {
        isChecked.toggle()
        let imageName = isChecked ? "checkmark.square" : "square"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
