//
//  PlayerDetailScreenVC.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 5.08.2024.
//

import UIKit

//MARK: - Protocol
protocol PlayerDetailScreenVCProtocol: AnyObject {
    func setupNavBarButton()
    func toggleEditing(isEditing: Bool)
    func configureImage(image: String)
    func configureLabels(name: String, position: String, skill: String)
    func setupPickerView()
    func reloadPickerView()
    func setupToolBar()
}

final class PlayerDetailScreenVC: UIViewController{
    
    //MARK: - Variables
    var viewModel: PLayerDetailScreenVMProtocol! {
        didSet {
            viewModel.view = self
        }
    }
    private var isEditingMode: Bool = false
    private let positionPickerView = UIPickerView()
    
    //MARK: - IBOutlets
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var detailNameTextField: UITextField!
    @IBOutlet private weak var detailPositionTextField: UITextField!
    @IBOutlet private weak var detailSkillTextField: UITextField!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var actionButtonStackView: UIStackView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupKeyboardObservers()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    //MARK: = Keyboard Observers
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomSpace = self.view.frame.height - (actionButtonStackView.frame.origin.y + actionButtonStackView.frame.height)
            if bottomSpace < keyboardHeight {
                self.view.frame.origin.y = 0 - (keyboardHeight - (bottomSpace) + 10)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    //MARK: - Private Action Button Functions
    @IBAction private func deleteButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: Constant.deleteTitle, message: Constant.deleteMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.cancel, style: .cancel))
        alert.addAction(UIAlertAction(title: Constant.deleteAction, style: .destructive, handler: { _ in
            self.viewModel.deletePlayer()
            self.viewModel.delegate?.playerDetailScreenDidDeletePlayer()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @IBAction private func editButtonClicked(_ sender: UIButton) {
        let name = detailNameTextField.text ?? ""
        let position = detailPositionTextField.text ?? ""
        let skill = Int(detailSkillTextField.text ?? "") ?? 0
        let imageData = detailImageView.image?.jpegData(compressionQuality: 0.5)
        let imageString = imageData?.base64EncodedString()
        guard let imageString else { return }
        
        let validationResult = viewModel.validatePlayerDetails(
            name: name,
            position: position,
            skill: String(skill),
            image: imageString
        )
        switch validationResult {
        case .success:
            let alert = UIAlertController(title: Constant.editTitle, message: Constant.editMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.cancel, style: .cancel))
            alert.addAction(UIAlertAction(title: Constant.editAction, style: .default, handler: { _ in
                self.saveChanges()
                self.viewModel.delegate?.playerDetailScreenDidEditPlayer()
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
            
        case .failure(let message):
            let alert = UIAlertController(title: Constant.editFailedTitle, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.ok, style: .default))
            present(alert, animated: true)
        }
    }
}

extension PlayerDetailScreenVC: PlayerDetailScreenVCProtocol {
    
    //MARK: - Update TextFields UI
    func toggleEditing(isEditing: Bool) {
        detailNameTextField.isEnabled = isEditing
        detailPositionTextField.isEnabled = isEditing
        detailSkillTextField.isEnabled = isEditing
    }
    
    //MARK: - Configure Variables
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
        detailNameTextField.placeholder = name
        detailSkillTextField.placeholder = skill
    }
    
    //MARK: - Navigation RightBar Button Items
    func setupNavBarButton() {
        if isEditingMode {
            let discardButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(discardButtonTapped))
            navigationItem.rightBarButtonItem = discardButton
        } else {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
            navigationItem.rightBarButtonItem = editButton
        }
    }
    
    //MARK: - Update Action Button UI
    private func updateActionButton() {
        editButton.isHidden = !isEditingMode
        deleteButton.isHidden = isEditingMode
    }
    
    //MARK: - Navigation RightBar Button Actions
    @objc private func editButtonTapped() {
        isEditingMode.toggle()
        toggleEditing(isEditing: isEditingMode)
        setupNavBarButton()
        updateActionButton()
        setupImageView()
    }
    
    @objc private func discardButtonTapped() {
        isEditingMode.toggle()
        toggleEditing(isEditing: self.isEditingMode)
        setupNavBarButton()
        updateActionButton()
        discardChanges()
    }
    
    private func discardChanges() {
        let player = viewModel.discardEditPlayer()
        detailNameTextField.text = player.name
        detailSkillTextField.text = String(describing: player.skillPoint ?? 0)
        detailPositionTextField.text = player.position
        configureImage(image: player.picture ?? "")
    }
    
    //MARK: - Action Button Activities
    private func saveChanges() {
        let name = detailNameTextField.text ?? ""
        let position = detailPositionTextField.text ?? ""
        let skill = Int(detailSkillTextField.text ?? "") ?? 0
        let resizedImage = detailImageView.image?.resize(targetSize: CGSize(width: 100, height: 100))
        let imageData = resizedImage?.jpegData(compressionQuality: 0.5)
        let imageString = imageData?.base64EncodedString()
        guard let imageString else { return }
        viewModel.updatePlayer(name: name, position: position, skill: skill, image: imageString)
    }
    
    //MARK: - UI Variables Setup and Update
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
        let cancelButton = UIBarButtonItem(title: Constant.cancel, style: .plain, target: self, action: #selector(cancelTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constant.next, style: .plain, target: self, action: #selector(nextTapped))
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
        let doneButton = UIBarButtonItem(title: Constant.done, style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }

    @objc private func doneTapped() {
        detailSkillTextField.resignFirstResponder()
    }
    
    private func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        detailImageView.isUserInteractionEnabled = true
        detailImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func imageViewTapped() {
        let actionSheet = UIAlertController(title: Constant.imageSourceTitle, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: Constant.photoLib, style: .default) { [weak self] _ in
            self?.presentImagePickerController(sourceType: .photoLibrary)
        }
        actionSheet.addAction(photoLibraryAction)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: Constant.camera, style: .default) { [weak self] _ in
                self?.presentImagePickerController(sourceType: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    
    private func presentImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
}

//MARK: - PickerView Extension
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

//MARK: - ImagePicker Extension
extension PlayerDetailScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            detailImageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: - TextField Extension
extension PlayerDetailScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == detailNameTextField {
            detailPositionTextField.becomeFirstResponder()
        }
        return true
    }
}

//MARK: - Constants Enum
private extension PlayerDetailScreenVC {
    enum Constant {
        static let cancel = "Cancel"
        static let ok = "OK"
        static let next = "Next"
        static let done = "Done"
        static let deleteTitle = "Delete Player"
        static let deleteMessage = "Are you sure you want to delete this player?"
        static let deleteAction = "Delete"
        static let editTitle = "Edit Player"
        static let editMessage = "Are you sure you want to edit this player?"
        static let editAction = "Edit"
        static let editFailedTitle = "Incomplete Information"
        static let camera = "Camera"
        static let photoLib = "Photo Library"
        static let imageSourceTitle = "Choose Image Source"
    }
}
