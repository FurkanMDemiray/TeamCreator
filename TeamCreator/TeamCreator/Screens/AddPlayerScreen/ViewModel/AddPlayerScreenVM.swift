//
//  AddPlayerScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 1.08.2024.
//

import Foundation


protocol AddPlayerScreenVMDelegate: AnyObject {
    
}

protocol AddPlayerScreenVMProtocol {
    var delegate: AddPlayerScreenVMDelegate? { get set }
}

final class AddPlayerScreenVM {
    weak var view: AddPlayersScreenVCProtocol?
    weak var delegate: AddPlayerScreenVMDelegate?
}

extension AddPlayerScreenVM: AddPlayerScreenVMProtocol {
    
}
