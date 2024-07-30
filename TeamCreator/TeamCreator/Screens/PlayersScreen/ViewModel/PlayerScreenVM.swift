//
//  PlayerScreenVM.swift
//  TeamCreator
//
//  Created by Agah Berkin Güler on 30.07.2024.
//

import Foundation

protocol PlayerScreenVMDelegate: AnyObject {
    
}

protocol PlayerScreenVMProtocol {
    var delegate: PlayerScreenVMDelegate? { get set }
    func viewDidLoad()
}

final class PlayerScreenVM {
    weak var view: PlayerScreenVCProtocol?
    weak var delegate: PlayerScreenVMDelegate?
    
    
}
