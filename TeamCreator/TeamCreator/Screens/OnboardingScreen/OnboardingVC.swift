//
//  OnboardingVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 12.08.2024.
//

import UIKit

final class OnboardingVC: UIViewController {

    @IBOutlet private weak var actionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func actionButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
