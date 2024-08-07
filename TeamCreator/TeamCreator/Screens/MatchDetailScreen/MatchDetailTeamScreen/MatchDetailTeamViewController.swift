//
//  MatchDetailTeamViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 1.08.2024.
//

import UIKit

final class MatchDetailTeamViewController: UIViewController {

    @IBOutlet private weak var gkImage: UIImageView!
    @IBOutlet private weak var gkLabel: UILabel!
    @IBOutlet private weak var rbImage: UIImageView!
    @IBOutlet private weak var rbLabel: UILabel!
    @IBOutlet private weak var cbImage: UIImageView!
    @IBOutlet private weak var cbLabel: UILabel!
    @IBOutlet private weak var secondCBImage: UIImageView!
    @IBOutlet private weak var secondCBLabel: UILabel!
    @IBOutlet private weak var lbImage: UIImageView!
    @IBOutlet private weak var lbLabel: UILabel!
    @IBOutlet private weak var rwImage: UIImageView!
    @IBOutlet private weak var rwLabel: UILabel!
    @IBOutlet private weak var cmImage: UIImageView!
    @IBOutlet private weak var cmLabel: UILabel!
    @IBOutlet private weak var secondCMImage: UIImageView!
    @IBOutlet private weak var secondCMLabel: UILabel!
    @IBOutlet private weak var lwImage: UIImageView!
    @IBOutlet private weak var lwLabel: UILabel!
    @IBOutlet private weak var cfImage: UIImageView!
    @IBOutlet private weak var cfLabel: UILabel!
    @IBOutlet private weak var secondCFImage: UIImageView!
    @IBOutlet private weak var secondCFLabel: UILabel!

    var viewModel: MatchDetailTeamViewModelProtocol! {
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
            case "Goalkeeper":
                gkImage.loadImage(from: player.picture)
                gkLabel.text = player.name
            case "Left Back":
                lbImage.loadImage(from: player.picture)
                lbLabel.text = player.name
            case "Center Back":
                if cbLabel.text == nil {
                    cbImage.loadImage(from: player.picture)
                    cbLabel.text = player.name
                } else {
                    secondCBImage.loadImage(from: player.picture)
                    secondCBLabel.text = player.name
                }
            case "Right Back":
                rbImage.loadImage(from: player.picture)
                rbLabel.text = player.name
            case "Center Midfielder":
                if cmLabel.text == nil {
                    cmImage.loadImage(from: player.picture)
                    cmLabel.text = player.name
                } else {
                    secondCMImage.loadImage(from: player.picture)
                    secondCMLabel.text = player.name
                }
            case "Right Winger":
                rwImage.loadImage(from: player.picture)
                rwLabel.text = player.name
            case "Left Winger":
                lwImage.loadImage(from: player.picture)
                lwLabel.text = player.name
            case "Center Forward":
                if cfLabel.text == nil {
                    cfImage.loadImage(from: player.picture)
                    cfLabel.text = player.name
                } else {
                    secondCFImage.loadImage(from: player.picture)
                    secondCFLabel.text = player.name
                }
            default:
                break
            }
        }
    }
}

extension MatchDetailTeamViewController: MatchDetailTeamViewModelDelegate {

}
