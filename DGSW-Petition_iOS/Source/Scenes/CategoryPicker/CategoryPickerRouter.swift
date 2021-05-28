//
//  CategoryPickerRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit

@objc protocol CategoryPickerRoutingLogic {
    func routeToPetitionWriteView(selectedCategoryIdx: Int, selectedCategoryName: String)
}

protocol CategoryPickerDataPassing {
    var dataStore: CategoryPickerDataStore? { get }
}

class CategoryPickerRouter: NSObject, CategoryPickerRoutingLogic, CategoryPickerDataPassing {
    weak var viewController: CategoryPickerViewController?
    var dataStore: CategoryPickerDataStore?
    
    // MARK: Routing (navigating to other screens)
    
    func routeToPetitionWriteView(selectedCategoryIdx: Int, selectedCategoryName: String) {
        let destinationVC = viewController?.navigationController?.viewControllers.filter { $0 is PetitionWriteViewController }.first as! PetitionWriteViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPetitionWriteView(selectedCategoryIdx: selectedCategoryIdx,
                                    selectedCategoryName: selectedCategoryName,
                                    destination: &destinationDS)
        navigateToPetitionWriteView(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation to other screen
    
    func navigateToPetitionWriteView(source: CategoryPickerViewController, destination: PetitionWriteViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data to other screen
    
    func passDataToPetitionWriteView(selectedCategoryIdx: Int, selectedCategoryName: String, destination: inout PetitionWriteDataStore) {
        destination.categoryIdx = selectedCategoryIdx
        destination.categoryName = selectedCategoryName
    }
}
