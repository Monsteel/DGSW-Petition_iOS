//
//  PetitionWriteRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

@objc protocol PetitionWriteRoutingLogic {
    func routeToCategoryPickerView()
    func routeToPreviousView()
}

protocol PetitionWriteDataPassing {
    var dataStore: PetitionWriteDataStore? { get }
}

class PetitionWriteRouter: NSObject, PetitionWriteRoutingLogic, PetitionWriteDataPassing {
    weak var viewController: PetitionWriteViewController?
    var dataStore: PetitionWriteDataStore?

// MARK: Routing (navigating to other screens)

    func routeToCategoryPickerView() {
        let destinationVC = CategoryPickerViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              let dataStore = dataStore,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToCategoryPickerView(source: dataStore, destination: &destinationDS)
        navigateToCategoryPickerView(source: viewController, destination: destinationVC)
    }
    
    func routeToPreviousView() {
        guard let viewController = viewController else { fatalError("Fail route to detail") }
        navigateToPreviousView(source: viewController)
    }
    
    
    //MARK: Navigation to other screen
    
    func navigateToCategoryPickerView(source: PetitionWriteViewController, destination: CategoryPickerViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToPreviousView(source: PetitionWriteViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Passing data to other screen
    
    func passDataToCategoryPickerView(source: PetitionWriteDataStore, destination: inout CategoryPickerDataStore) {
        destination.selectedCategoryIdx = source.categoryIdx
    }

}
