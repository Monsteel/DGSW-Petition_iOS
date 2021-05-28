//
//  HomeRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

@objc protocol HomeRoutingLogic {
    func routeToWritePetitionView()
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
    
    
    //MARK: Navigation to other screen
    
    func navigateToWritePetitionView(source: HomeViewController, destination: PetitionWriteViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    //MARK: Passing data to other screen
    
    func passDataToWritePetitionView(source: HomeDataStore, destination: inout PetitionWriteDataStore) {
        //Nottingw
    }
}
