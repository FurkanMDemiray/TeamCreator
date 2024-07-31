//
//  CreateMatchDetailViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 31.07.2024.
//

import Foundation

protocol CreateMatchDetailViewModelDelegate: AnyObject {

}

protocol CreateMatchDetailViewModelProtocol {
    var delegate: CreateMatchDetailViewModelDelegate? { get set }
}

final class CreateMatchDetailViewModel: CreateMatchDetailViewModelProtocol {
    weak var delegate: CreateMatchDetailViewModelDelegate?


}

extension CreateMatchDetailViewModel: CreateMatchDetailViewModelDelegate {

}


