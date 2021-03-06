//
//  HomeRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

@objc protocol HomeRoutingLogic {
    func routeToWritePetitionView()
    func routeToSearchView(_ keyword: String)
    func routeToDetailPetitionView(_ idx: Int)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    //MARK: Routing (navigating to other screens)
    
    func routeToWritePetitionView() {
        let destinationVC = PetitionWriteViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              let dataStore = dataStore,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToWritePetitionView(source: dataStore, destination: &destinationDS)
        navigateToWritePetitionView(source: viewController, destination: destinationVC)
    }
    
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
    
    func routeToSearchView(_ keyword: String) {
        let destinationVC = SearchViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToSearchView(keyword: keyword, destination: &destinationDS)
        navigateToSearchView(source: viewController, destination: destinationVC)
    }
    
    //MARK: Navigation to other screen
    
    func navigateToSearchView(source: HomeViewController, destination: SearchViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToWritePetitionView(source: HomeViewController, destination: PetitionWriteViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToDetailPetitionView(source: HomeViewController, destination: DetailPetitionViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    //MARK: Passing data to other screen
    
    func passDataToWritePetitionView(source: HomeDataStore, destination: inout PetitionWriteDataStore) {
        //Nottingw
    }
    
    func passDataToSearchView(keyword: String, destination: inout SearchDataStore) {
        destination.searchKeyword = keyword
    }
    
    func passDataToDetailPetitionView(idx: Int, destination: inout DetailPetitionDataStore) {
        destination.petitionIdx = idx
    }
    
}
