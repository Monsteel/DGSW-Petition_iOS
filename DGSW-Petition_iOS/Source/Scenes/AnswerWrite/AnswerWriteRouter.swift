//
//  AnswerWriteRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/24.
//

import UIKit

@objc protocol AnswerWriteRoutingLogic {
    func routeToPreviousView()
}

protocol AnswerWriteDataPassing {
    var dataStore: AnswerWriteDataStore? { get }
}

class AnswerWriteRouter: NSObject, AnswerWriteRoutingLogic, AnswerWriteDataPassing {
    weak var viewController: AnswerWriteViewController?
    var dataStore: AnswerWriteDataStore?

// MARK: Routing (navigating to other screens)
    
    func routeToPreviousView() {
        guard let viewController = viewController else { fatalError("Fail route to detail") }
        navigateToPreviousView(source: viewController)
    }
    
    
    //MARK: Navigation to other screen
    
    func navigateToPreviousView(source: AnswerWriteViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Passing data to other screen

}
