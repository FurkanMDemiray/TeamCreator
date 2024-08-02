//
//  HomeViewModel.swift
//  TeamCreator
//
//  Created by Melik Demiray on 29.07.2024.
//

import Foundation

enum Sport: String {
    case football
    case volleyball
}

protocol HomeViewModelDelegate: AnyObject {

}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }

}

final class HomeViewModel {

    weak var delegate: HomeViewModelDelegate?
    var networkManager: NetworkManagerProtocol?


}

extension HomeViewModel: HomeViewModelProtocol {

}
