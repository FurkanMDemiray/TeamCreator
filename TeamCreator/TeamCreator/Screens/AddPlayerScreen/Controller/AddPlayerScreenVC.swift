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
    func setupImageView()
    func showError(message: String)
    func clearFields()
}

final class AddPlayerScreenVC: UIViewController {

    var viewModel = AddPlayerScreenVM()

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var ratingTextField: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    private let positionPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.delegate = self
        viewModel.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction private func addPlayerButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text
        let surname = surnameTextField.text
        let position = positionTextField.text
        let rating = ratingTextField.text
        let id = UUID().uuidString

        let newPlayer = Player(id: id, name: "\(name!) \(surname!)", age: 18, skillPoint: Int(rating ?? "0"), position: position)

        viewModel.addPlayer(player: newPlayer)

    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomSpace = self.view.frame.height - (addPlayerButton.frame.origin.y + addPlayerButton.frame.height)
            if bottomSpace < keyboardHeight {
                self.view.frame.origin.y = 0 - (keyboardHeight - (bottomSpace))
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
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
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
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

    func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func imageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Empty Field", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func clearFields() {
        nameTextField.text = ""
        surnameTextField.text = ""
        positionTextField.text = ""
        ratingTextField.text = ""
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

extension AddPlayerScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            //TODO: save image?
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddPlayerScreenVC: AddPlayerScreenVMDelegate {
    func navigateBackToPlayers() {
        navigationController?.popViewController(animated: true)
    }
}
