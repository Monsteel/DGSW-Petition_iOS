//
//  AwaitingRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

@objc protocol AwaitingRoutingLogic {
    func routeToWritePetitionView()
    func routeToDetailPetitionView(_ idx: Int)
}

protocol AwaitingDataPassing {
    var dataStore: AwaitingDataStore? { get }
}

class AwaitingRouter: NSObject, AwaitingRoutingLogic, AwaitingDataPassing {
    weak var viewController: AwaitingViewController?
    var dataStore: AwaitingDataStore?

// MARK: Routing (navigating to other screens)
    
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
    
    
    //MARK: Navigation to other screen
    
    func navigateToWritePetitionView(source: AwaitingViewController, destination: PetitionWriteViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToDetailPetitionView(source: AwaitingViewController, destination: DetailPetitionViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    //MARK: Passing data to other screen
    
    func passDataToWritePetitionView(source: AwaitingDataStore, destination: inout PetitionWriteDataStore) {
        //Nottingw
    }
    
    func passDataToDetailPetitionView(idx: Int, destination: inout DetailPetitionDataStore) {
        destination.petitionIdx = idx
    }
}
