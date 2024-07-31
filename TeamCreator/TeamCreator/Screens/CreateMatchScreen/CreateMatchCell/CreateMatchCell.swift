//
//  PlayerCell.swift
//  TeamCreator
//
//  Created by Melik Demiray on 30.07.2024.
//

import UIKit

class CreateMatchCell: UITableViewCell {

    static let createMatchCellId = "PlayerCell"
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    private var isChecked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButton()
    }

    func configure(with name: String) {
        playerNameLabel.text = name
    }

    private func configureButton() {
        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    @IBAction func checkButtonClicked(_ sender: UIButton) {
        isChecked.toggle()
        let imageName = isChecked ? "checkmark.square" : "square"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
