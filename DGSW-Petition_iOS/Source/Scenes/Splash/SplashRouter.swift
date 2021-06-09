//
//  SplashRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import UIKit

@objc protocol SplashRoutingLogic {
    func routeToWelcomeView()
    func routeToMainView()
}

protocol SplashDataPassing {
    var dataStore: SplashDataStore? { get }
}

class SplashRouter: NSObject, SplashRoutingLogic, SplashDataPassing {
    weak var viewController: SplashViewController?
    var dataStore: SplashDataStore?

// MARK: Routing (navigating to other screens)

    func routeToWelcomeView() {
        let destinationVC = WelcomeViewController().then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController,
              let dataStore = dataStore,
              var destinationDS = destinationVC.router?.dataStore
              else { fatalError("Fail route to detail") }
        
        passDataToWelcomeView(source: dataStore, destination: &destinationDS)
        navigateToWelcomeView(source: viewController, destination: destinationVC)
    }
    
    func routeToMainView() {
        let destinationVC = UINavigationController(rootViewController: MainViewController()).then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let viewController = viewController else { fatalError("Fail route to detail") }
       
        navigateToMainView(source: viewController, destination: destinationVC)
    }
    
    //MARK: Navigation to other screen
    
    func navigateToWelcomeView(source: SplashViewController, destination: WelcomeViewController) {
        source.present(destination, animated: false)
    }
    
    func navigateToMainView(source: SplashViewController, destination: UINavigationController) {
        source.present(destination, animated: false)
    }
    
    //MARK: Passing data to other screen
    
    func passDataToWelcomeView(source: SplashDataStore, destination: inout WelcomeDataStore) {
        //Notting
    }
}
