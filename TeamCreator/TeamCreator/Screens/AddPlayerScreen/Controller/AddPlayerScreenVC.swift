//
//  AddPlayerScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 1.08.2024.
//

import UIKit

//MARK: - Protocol
protocol AddPlayerScreenVCProtocol: AnyObject {
    func setupVC()
    func setupPickerView()
    func reloadPickerView()
    func setupImageView()
    func showError(message: String)
    func clearFields()
}

//MARK: - Class
final class AddPlayerScreenVC: UIViewController {
    
    //MARK: - Variables
    var viewModel: AddPlayerScreenVMProtocol! {
        didSet {
            viewModel.view = self
            viewModel.delegate = self
        }
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var ratingTextField: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    
    private let positionPickerView = UIPickerView()
    private var activeTextField: UITextField?

    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private Functions
    @IBAction private func addPlayerButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text
        let surname = surnameTextField.text
        let position = positionTextField.text
        let rating = ratingTextField.text
        let id = UUID().uuidString
        var imageString: String? = nil
        if imageView.image !=  UIImage(systemName: "hand.tap.fill") {
            if let imageData = imageView.image?.jpegData(compressionQuality: 0.5) {
                imageString = imageData.base64EncodedString()
            }
        }
        let newPlayer = Player(id: id, name: "\(name!) \(surname!)", age: 18, skillPoint: Int(rating ?? "0"), position: position, sport: HomeViewModel.whichSport, picture: imageString)
        
        let validationResult = viewModel.validatePlayerDetails(player: newPlayer)
        switch validationResult {
        case .success:
            viewModel.addPlayer(player: newPlayer)
        case .failure(let message):
            let alert = UIAlertController(title: "Incomplete Information", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = activeTextField else { return }

        let textFieldFrameInWindow = activeTextField.convert(activeTextField.bounds, to: view.window)

        let textFieldBottomY = textFieldFrameInWindow.maxY
        let keyboardOriginY = view.frame.height - keyboardFrame.height

        if textFieldBottomY > keyboardOriginY {
            let offset = textFieldBottomY - keyboardOriginY + 50
            self.view.frame.origin.y = 0 - offset
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension AddPlayerScreenVC: AddPlayerScreenVCProtocol {

    //MARK: - PickerView
    func setupPickerView() {
        positionPickerView.delegate = self
        positionPickerView.dataSource = self
        positionTextField.inputView = positionPickerView
    }

    func reloadPickerView() {
        positionPickerView.reloadAllComponents()
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
    
    //MARK: - ImageView
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

//MARK: - TextField Extension
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}

//MARK: - PickerView Extension
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

//MARK: - ImagePicker Extension
extension AddPlayerScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: - Delegate Extension
extension AddPlayerScreenVC: AddPlayerScreenVMDelegate {
    func navigateBackToPlayers() {
        navigationController?.popViewController(animated: true)
    }
}
