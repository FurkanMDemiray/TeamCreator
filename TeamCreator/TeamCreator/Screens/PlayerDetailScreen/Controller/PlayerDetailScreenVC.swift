//
//  PlayerDetailScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import UIKit

protocol PlayerDetailScreenVCProtocol: AnyObject {
    func setupEditButton()
    func toggleEditing(isEditing: Bool)
    func configureImage(image: String)
    func configureLabels(name: String, position: String, skill: String)
    func setupPickerView()
    func reloadPickerView()
    func setupToolBar()
}

final class PlayerDetailScreenVC: UIViewController{
    
    var viewModel: PLayerDetailScreenVMProtocol! {
        didSet {
            viewModel.view = self
        }
    }
    
    private var isEditingMode: Bool = false
    
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var detailNameTextField: UITextField!
    @IBOutlet private weak var detailPositionTextField: UITextField!
    @IBOutlet private weak var detailSkillTextField: UITextField!
    private let positionPickerView = UIPickerView()
    @IBOutlet private weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomSpace = self.view.frame.height - (deleteButton.frame.origin.y + deleteButton.frame.height)
            if bottomSpace < keyboardHeight {
                self.view.frame.origin.y = 0 - (keyboardHeight - (bottomSpace) + 10)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    @IBAction private func deleteButtonClicked(_ sender: UIButton) {
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
    
    func toggleEditing(isEditing: Bool) {
        detailNameTextField.isEnabled = isEditing
        detailPositionTextField.isEnabled = isEditing
        detailSkillTextField.isEnabled = isEditing
        
        if isEditing {
            detailNameTextField.borderStyle = .roundedRect
            detailPositionTextField.borderStyle = .roundedRect
            detailSkillTextField.borderStyle = .roundedRect
        } else {
            detailNameTextField.borderStyle = .none
            detailPositionTextField.borderStyle = .none
            detailSkillTextField.borderStyle = .none
        }
    }
    
    func configureImage(image: String) {
      encodeImage(image: image)
    }
    
    private func encodeImage(image: String) {
        let imageData = Data(base64Encoded: image)
        let image = UIImage(data: imageData ?? Data())
        detailImageView.image = image
    }
    
    func configureLabels(name: String, position: String, skill: String) {
        detailNameTextField.text = name
        detailPositionTextField.text = position
        detailSkillTextField.text = skill
    }
    
    func setupEditButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func editButtonTapped() {
        isEditingMode.toggle()
        toggleEditing(isEditing: isEditingMode)
        if !isEditingMode {
            saveChanges()
        }
    }
    
    private func saveChanges() {
        let name = detailNameTextField.text ?? ""
        let position = detailPositionTextField.text ?? ""
        let skill = Int(detailSkillTextField.text ?? "") ?? 0
        viewModel.updatePlayer(name: name, position: position, skill: skill)
    }
    
    func setupPickerView() {
        positionPickerView.delegate = self
        positionPickerView.dataSource = self
        detailPositionTextField.inputView = positionPickerView
    }
    
    func reloadPickerView() {
        positionPickerView.reloadAllComponents()
    }
    
    func setupToolBar() {
        setupPickerViewToolBar(for: detailPositionTextField)
        setupNumberPadToolBar(for: detailSkillTextField)
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
        detailPositionTextField.resignFirstResponder()
    }

    @objc private func nextTapped() {
        let selectedRow = positionPickerView.selectedRow(inComponent: 0)
        detailPositionTextField.text = viewModel.titleForRow(row: selectedRow)
        detailPositionTextField.resignFirstResponder()
        detailSkillTextField.becomeFirstResponder()
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
        detailSkillTextField.resignFirstResponder()
    }

    
}

extension PlayerDetailScreenVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRows()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.titleForRow(row: row)
    }
}

extension PlayerDetailScreenVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        detailPositionTextField.text = viewModel.titleForRow(row: row)
    }
}
