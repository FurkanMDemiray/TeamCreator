//
//  HomeViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 29.07.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject { }

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    var networkManager: NetworkManagerProtocol?
    static var whichSport = ""
}

extension HomeViewModel: HomeViewModelProtocol { }
