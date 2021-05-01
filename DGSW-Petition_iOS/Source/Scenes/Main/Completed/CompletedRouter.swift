//
//  CompletedRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

@objc protocol CompletedRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol CompletedDataPassing {
    var dataStore: CompletedDataStore? { get }
}

class CompletedRouter: NSObject, CompletedRoutingLogic, CompletedDataPassing {
    weak var viewController: CompletedViewController?
    var dataStore: CompletedDataStore?

// MARK: Routing (navigating to other screens)

//func routeToSomewhere(segue: UIStoryboardSegue?) {
//    if let segue = segue {
//        let destinationVC = segue.destination as! SomewhereViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//    } else {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        navigateToSomewhere(source: viewController!, destination: destinationVC)
//    }
//}

// MARK: Navigation to other screen

//func navigateToSomewhere(source: CompletedViewController, destination: SomewhereViewController) {
//    source.show(destination, sender: nil)
//}

// MARK: Passing data to other screen

//    func passDataToSomewhere(source: CompletedDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
