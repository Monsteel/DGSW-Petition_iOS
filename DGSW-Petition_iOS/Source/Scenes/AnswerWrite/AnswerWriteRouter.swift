//
//  AnswerWriteRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/24.
//

import UIKit

@objc protocol AnswerWriteRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AnswerWriteDataPassing {
    var dataStore: AnswerWriteDataStore? { get }
}

class AnswerWriteRouter: NSObject, AnswerWriteRoutingLogic, AnswerWriteDataPassing {
    weak var viewController: AnswerWriteViewController?
    var dataStore: AnswerWriteDataStore?

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
//
// MARK: Navigation to other screen
//
//func navigateToSomewhere(source: AnswerWriteViewController, destination: SomewhereViewController) {
//    source.show(destination, sender: nil)
//}
//
// MARK: Passing data to other screen
//
//    func passDataToSomewhere(source: AnswerWriteDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
