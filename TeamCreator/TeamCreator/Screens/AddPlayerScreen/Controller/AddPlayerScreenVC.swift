//
//  AddPlayerScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 1.08.2024.
//

import UIKit

protocol AddPlayersScreenVCProtocol: AnyObject {
    func setupVC()
    func setupPickerView()
}

final class AddPlayerScreenVC: UIViewController {

    private let viewModel = AddPlayerScreenVM()
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var ratingTextField: UITextField!
    
    private let positionPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
    
    @IBAction private func addPlayerButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let surname = surnameTextField.text, !surname.isEmpty,
              let position = positionTextField.text, !position.isEmpty,
              let ratingText = ratingTextField.text, let rating = Int(ratingText), rating >= 1, rating <= 99
        else {
            print("Please fill out all fields correctly.")
            return
        }
        print("Name: \(name) \(surname), Position: \(position), Rating: \(rating)")

    }
    

}

extension AddPlayerScreenVC: AddPlayersScreenVCProtocol {
    
    func setupPickerView() {
        positionPickerView.delegate = self
        positionPickerView.dataSource = self
        positionTextField.inputView = positionPickerView
    }
    
    func setupVC() {
        setupPickerViewToolBar(for: positionTextField)
        setupNumberPadToolBar(for: ratingTextField)
    }
    
    private func setupPickerViewToolBar(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        toolbar.setItems([cancelButton,flexibleSpace,doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func cancelTapped() {
        positionTextField.resignFirstResponder()
    }

    @objc private func nextTapped() {
        let selectedRow = positionPickerView.selectedRow(inComponent: 0)
        positionTextField.text = viewModel.titleForRow(row: selectedRow)
        positionTextField.resignFirstResponder()
        ratingTextField.becomeFirstResponder()
    }
    
    private func setupNumberPadToolBar(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func doneTapped() {
        ratingTextField.resignFirstResponder()
    }

    
}

extension AddPlayerScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            surnameTextField.becomeFirstResponder()
        } else if textField == surnameTextField {
            positionTextField.becomeFirstResponder()
        } else if textField == positionTextField {
            ratingTextField.becomeFirstResponder()
        } else if textField == ratingTextField {
            ratingTextField.resignFirstResponder()
        }
        return true
    }
}

extension AddPlayerScreenVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForRow(row: row)
    }
}

extension AddPlayerScreenVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        positionTextField.text = viewModel.titleForRow(row: row)
    }
}
