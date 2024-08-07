//
//  VolleyballViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 3.08.2024.
//

import UIKit

final class VolleyballViewController: UIViewController {

    @IBOutlet private weak var oImage: UIImageView!
    @IBOutlet private weak var oLabel: UILabel!
    @IBOutlet private weak var mbImage: UIImageView!
    @IBOutlet private weak var mbLabel: UILabel!
    @IBOutlet private weak var rhImage: UIImageView!
    @IBOutlet private weak var rhLabel: UILabel!
    @IBOutlet private weak var ohImage: UIImageView!
    @IBOutlet private weak var ohLabel: UILabel!
    @IBOutlet private weak var liberoImage: UIImageView!
    @IBOutlet private weak var liberoLabel: UILabel!
    @IBOutlet private weak var sImage: UIImageView!
    @IBOutlet private weak var sLabel: UILabel!

    var viewModel: VolleyballViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayers()
    }

    private func setPlayers() {
        let players = viewModel.getTeam
        for player in players {
            switch player.position {
            case "Setter":
                sImage.loadImage(from: player.picture)
                sLabel.text = player.name
            case "Outside Hitter":
                if ohLabel.text == nil {
                    ohImage.loadImage(from: player.picture)
                    ohLabel.text = player.name
                } else {
                    rhImage.loadImage(from: player.picture)
                    rhLabel.text = player.name
                }
            case "Middle Blocker":
                if mbLabel.text == nil {
                    mbImage.loadImage(from: player.picture)
                    mbLabel.text = player.name
                } else {
                    liberoImage.loadImage(from: player.picture)
                    liberoLabel.text = player.name
                }
            case "Opposite":
                oImage.loadImage(from: player.picture)
                oLabel.text = player.name
            case "Libero":
                liberoImage.loadImage(from: player.picture)
                liberoLabel.text = player.name
            case "Right Side Hitter":
                rhImage.loadImage(from: player.picture)
                rhLabel.text = player.name
            default:
                break
            }
        }
    }
}

extension VolleyballViewController: VolleyballViewModelDelegate {

}
