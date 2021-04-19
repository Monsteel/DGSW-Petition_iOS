//
//  SplashRouter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import Foundation

@objc protocol SplashRoutingLogic {
    
}

protocol SplashDataPassing {
    var dataStore: SplashDataStore? { get }
}

class SplashRouter: NSObject, SplashRoutingLogic, SplashDataPassing  {
    weak var viewController: SplashViewController?
    
    var dataStore: SplashDataStore?
    
    
}
