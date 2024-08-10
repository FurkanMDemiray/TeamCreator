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
    func registerTableView()
    func reloadTableView()
}

//MARK: - Class
final class PlayerDetailScreenVC: UIViewController{
    
    //MARK: - Variables
    var viewModel: PlayerDetailScreenVMProtocol! {
        didSet {
            viewModel.view = self
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var actionButtonStackView: UIStackView!
    
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
    
    //MARK: - Private functions
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

    @IBAction private func deleteButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction private func editButtonClicked(_ sender: UIButton) {
        
    }
}

extension PlayerDetailScreenVC: PlayerDetailScreenVCProtocol {
    
    func registerTableView() {
        tableView.registerCell(type: PlayerDetailImageCell.self)
        tableView.registerCell(type: PlayerDetailNameCell.self)
        tableView.registerCell(type: PlayerDetailPositionCell.self)
        tableView.registerCell(type: PlayerDetailSkillCell.self)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    //MARK: - Update TextFields UI
    func toggleEditing(isEditing: Bool) {
        tableView.visibleCells.forEach { cell in
            if let editableCell = cell as? EditableCellProtocol {
                editableCell.setEditing(isEditing: isEditing)
            }
        }
    }
    
    //MARK: - Navigation RightBar Button Items
    func setupNavBarButton() {
        if viewModel.getEditingMode() {
            let discardButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(discardButtonTapped))
            navigationItem.rightBarButtonItem = discardButton
        } else {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
            navigationItem.rightBarButtonItem = editButton
        }
    }
    
    //MARK: - Update Action Button UI
    private func updateActionButton() {
        editButton.isHidden = !viewModel.getEditingMode()
        deleteButton.isHidden = viewModel.getEditingMode()
    }
    
    //MARK: - Navigation RightBar Button Actions
    @objc private func editButtonTapped() {
        viewModel.changeEditingMode(viewModel.getEditingMode())
        toggleEditing(isEditing: viewModel.getEditingMode())
        setupNavBarButton()
        updateActionButton()
    }
    
    @objc private func discardButtonTapped() {
        viewModel.changeEditingMode(viewModel.getEditingMode())
        self.toggleEditing(isEditing: viewModel.getEditingMode())
        self.setupNavBarButton()
        self.updateActionButton()
        self.discardChanges()
        
    }
    
    //MARK: - Action Button Activities
    private func discardChanges() {
        
    }
    
    
    private func saveChanges() {
       
    }
}

//MARK: - UITableView Extension
extension PlayerDetailScreenVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellVM = viewModel.cellForRow(at: indexPath)
        
        switch cellVM {
        case let imageCellVM as PlayerDetailImageCellVM:
            if let cell = tableView.dequeueCell(withType: PlayerDetailImageCell.self) as? PlayerDetailImageCell {
                cell.prepareCell(with: imageCellVM)
                return cell
            }
        case let nameCellVM as PlayerDetailNameCellVM:
            if let cell = tableView.dequeueCell(withType: PlayerDetailNameCell.self) as? PlayerDetailNameCell {
                cell.prepareCell(with: nameCellVM)
                return cell
            }
        case let positionCellVM as PlayerDetailPositionCellVM:
            if let cell = tableView.dequeueCell(withType: PlayerDetailPositionCell.self) as? PlayerDetailPositionCell {
                cell.prepareCell(with: positionCellVM)
                return cell
            }
        case let skillCellVM as PlayerDetailSkillCellVM:
            if let cell = tableView.dequeueCell(withType: PlayerDetailSkillCell.self) as? PlayerDetailSkillCell {
                cell.prepareCell(with: skillCellVM)
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension PlayerDetailScreenVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(at: indexPath)
    }
}


