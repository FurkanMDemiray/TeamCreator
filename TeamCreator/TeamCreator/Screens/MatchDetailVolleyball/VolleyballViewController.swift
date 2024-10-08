//
//  VolleyballViewController.swift
//  TeamCreator
//
//  Created by Melik Demiray on 3.08.2024.
//

import UIKit

final class VolleyballViewController: UIViewController {

    var viewModel: VolleyballViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    //MARK: - IBOutlets
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImages()
        setPlayers()
    }

    private func configureImages() {
        oImage.layer.cornerRadius = oImage.frame.width / 2
        oImage.clipsToBounds = true
        mbImage.layer.cornerRadius = mbImage.frame.width / 2
        mbImage.clipsToBounds = true
        rhImage.layer.cornerRadius = rhImage.frame.width / 2
        rhImage.clipsToBounds = true
        ohImage.layer.cornerRadius = ohImage.frame.width / 2
        ohImage.clipsToBounds = true
        liberoImage.layer.cornerRadius = liberoImage.frame.width / 2
        liberoImage.clipsToBounds = true
        sImage.layer.cornerRadius = sImage.frame.width / 2
        sImage.clipsToBounds = true
    }

    private func setPlayers() {
        let players = viewModel.getTeam
        for player in players {
            switch player.position {
            case "Setter":
                sImage.loadImage(from: player.picture)
                sLabel.text = player.name
            case "Outside Hitter":
                ohImage.loadImage(from: player.picture)
                ohLabel.text = player.name
            case "Middle Blocker":
                mbImage.loadImage(from: player.picture)
                mbLabel.text = player.name
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

extension VolleyballViewController: VolleyballViewModelDelegate { }
