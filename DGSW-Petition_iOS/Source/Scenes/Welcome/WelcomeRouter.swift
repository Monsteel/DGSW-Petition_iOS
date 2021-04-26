//
//  WelcomeRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import UIKit

@objc protocol WelcomeRoutingLogic {
    func routeToRegisterView(segue: UIStoryboardSegue?)
}

protocol WelcomeDataPassing {
    var dataStore: WelcomeDataStore? { get }
}

class WelcomeRouter: NSObject, WelcomeRoutingLogic, WelcomeDataPassing {
    weak var viewController: WelcomeViewController?
    var dataStore: WelcomeDataStore?

// MARK: Routing (navigating to other screens)

func routeToRegisterView(segue: UIStoryboardSegue?) {
    if let segue = segue {
        let destinationVC = segue.destination as! RegisterViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    } else {
        let destinationVC = RegisterViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              let dataStore = dataStore,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToSomewhere(source: dataStore, destination: &destinationDS)
        navigateToSomewhere(source: viewController, destination: destinationVC)
    }
}

// MARK: Navigation to other screen

func navigateToSomewhere(source: WelcomeViewController, destination: RegisterViewController) {
    source.navigationController?.pushViewController(destination, animated: true)
}

// MARK: Passing data to other screen

    func passDataToSomewhere(source: WelcomeDataStore, destination: inout RegisterDataStore) {
        destination.googleToken = source.googleToken
        destination.userID = source.userID
    }
}
