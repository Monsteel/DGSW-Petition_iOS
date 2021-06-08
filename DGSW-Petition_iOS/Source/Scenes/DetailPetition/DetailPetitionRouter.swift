//
//  DetailPetitionRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit

@objc protocol DetailPetitionRoutingLogic {
    func routeToWritePetitionView(_ idx: Int)
    func routeToWriteAnswerView(_ idx: Int)
    func routeToPreviousView()
}

protocol DetailPetitionDataPassing {
    var dataStore: DetailPetitionDataStore? { get }
}

class DetailPetitionRouter: NSObject, DetailPetitionRoutingLogic, DetailPetitionDataPassing {
    weak var viewController: DetailPetitionViewController?
    var dataStore: DetailPetitionDataStore?

// MARK: Routing (navigating to other screens)
    
    func routeToWritePetitionView(_ idx: Int) {
        let destinationVC = PetitionWriteViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToWritePetitionView(idx: idx, destination: &destinationDS)
        navigateToWritePetitionView(source: viewController, destination: destinationVC)
    }
    
    func routeToPreviousView() {
        guard let viewController = viewController else { fatalError("Fail route to detail") }
        navigateToPreviousView(source: viewController)
    }
    
    func routeToWriteAnswerView(_ idx: Int) {
        let destinationVC = AnswerWriteViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToWriteAnswerView(idx: idx, destination: &destinationDS)
        navigateToWriteAnswerView(source: viewController, destination: destinationVC)
    }

// MARK: Navigation to other screen

    func navigateToWritePetitionView(source: DetailPetitionViewController, destination: PetitionWriteViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToWriteAnswerView(source: DetailPetitionViewController, destination: AnswerWriteViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToPreviousView(source: DetailPetitionViewController) {
        source.navigationController?.popViewController(animated: true)
    }

// MARK: Passing data to other screen

    func passDataToWritePetitionView(idx: Int, destination: inout PetitionWriteDataStore) {
        destination.idx = idx
    }
    
    func passDataToWriteAnswerView(idx: Int, destination: inout AnswerWriteDataStore) {
        destination.targetPetitionIdx = idx
    }
}
