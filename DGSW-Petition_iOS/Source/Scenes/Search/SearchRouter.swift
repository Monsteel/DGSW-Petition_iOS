//
//  SearchRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

@objc protocol SearchRoutingLogic {
    func routeToDetailPetitionView(_ idx: Int)
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing {
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?

// MARK: Routing (navigating to other screens)

    func routeToDetailPetitionView(_ idx: Int) {
        let destinationVC = DetailPetitionViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToDetailPetitionView(idx: idx, destination: &destinationDS)
        navigateToDetailPetitionView(source: viewController, destination: destinationVC)
    }

// MARK: Navigation to other screen

    func navigateToDetailPetitionView(source: SearchViewController, destination: DetailPetitionViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }

// MARK: Passing data to other screen

    func passDataToDetailPetitionView(idx: Int, destination: inout DetailPetitionDataStore) {
        destination.petitionIdx = idx
    }
}
