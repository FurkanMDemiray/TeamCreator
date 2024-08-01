//
//  AddPlayerScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 1.08.2024.
//

import UIKit

protocol AddPlayersScreenVCProtocol: AnyObject {
    
}

final class AddPlayerScreenVC: UIViewController {

    private let viewModel = AddPlayerScreenVM()
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var ratingTextField: UITextField!
    
    private let positonPickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        
        
    }

}

extension AddPlayerScreenVC: AddPlayersScreenVCProtocol {
    
}
