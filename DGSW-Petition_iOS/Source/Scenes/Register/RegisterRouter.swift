//
//  RegisterRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/22.
//

import UIKit

@objc protocol RegisterRoutingLogic {
    func routeToWelcomeView(segue: UIStoryboardSegue?)
}

protocol RegisterDataPassing {
    var dataStore: RegisterDataStore? { get }
}

class RegisterRouter: NSObject, RegisterRoutingLogic, RegisterDataPassing {
    weak var viewController: RegisterViewController?
    var dataStore: RegisterDataStore?
    
    // MARK: Routing (navigating to other screens)

    func routeToWelcomeView(segue: UIStoryboardSegue?) {
        let destinationVC = viewController?.navigationController?.viewControllers.first as! WelcomeViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }

    // MARK: Navigation to other screen

    func navigateToSomewhere(source: RegisterViewController, destination: WelcomeViewController) {
        source.navigationController?.popViewController(animated: true)
    }

    // MARK: Passing data to other screen

    func passDataToSomewhere(source: RegisterDataStore, destination: inout WelcomeDataStore) {
        destination.isSuccessRegistered = source.isSuccessRegistered
        destination.userID = source.userID
    }
}
