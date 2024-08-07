//
//  PlayerDetailScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import UIKit

protocol PlayerDetailScreenVCProtocol: AnyObject {
    func configureImage(image: String)
    func configureLabels(name: String, position: String, skill: String)
}

final class PlayerDetailScreenVC: UIViewController{
    
    var viewModel: PLayerDetailScreenVMProtocol! {
        didSet {
            viewModel.view = self
        }
    }
    
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var detailNameLabel: UILabel!
    @IBOutlet private weak var detailPositionLabel: UILabel!
    @IBOutlet private weak var detailSkillLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Player", message: "Are you sure you want to delete this player?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel.deletePlayer()
            self.viewModel.delegate?.playerDetailScreenDidDeletePlayer()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
}

extension PlayerDetailScreenVC: PlayerDetailScreenVCProtocol {
    func configureImage(image: String) {
      encodeImage(image: image)
    }
    
    private func encodeImage(image: String) {
        let imageData = Data(base64Encoded: image)
        let image = UIImage(data: imageData ?? Data())
        detailImageView.image = image
    }
    
    func configureLabels(name: String, position: String, skill: String) {
        detailNameLabel.text = name
        detailPositionLabel.text = position
        detailSkillLabel.text = skill
    }
}
