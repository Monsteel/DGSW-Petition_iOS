//
//  DetailPetitionRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit

@objc protocol DetailPetitionRoutingLogic {
//    func routeToUIView()
}

protocol DetailPetitionDataPassing {
    var dataStore: DetailPetitionDataStore? { get }
}

class DetailPetitionRouter: NSObject, DetailPetitionRoutingLogic, DetailPetitionDataPassing {
    weak var viewController: DetailPetitionViewController?
    var dataStore: DetailPetitionDataStore?

// MARK: Routing (navigating to other screens)
    
//    func routeToUIView() {
//        let destinationVC = UIViewController().then {
//            $0.modalPresentationStyle = .fullScreen
//        }
//
//        guard let viewController = viewController,
//              let dataStore = dataStore,
//              var destinationDS = destinationVC.router?.dataStore
//        else { fatalError("Fail route to detail") }
//
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        navigateToSomewhere(source: viewController!, destination: destinationVC)
//    }

// MARK: Navigation to other screen

//    func navigateToUIView(source: DetailPetitionViewController, destination: UIViewController) {
//        source.show(destination, sender: nil)
//    }

// MARK: Passing data to other screen

//    func passDataToUIView(source: DetailPetitionDataStore, destination: inout UIDataSource) {
//        destination.name = source.name
//    }
}
