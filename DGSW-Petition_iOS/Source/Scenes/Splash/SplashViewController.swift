//
//  SplashViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit
import SnapKit

protocol SplashDisplayLogic:class {
    
}

class SplashViewController:DGSW_Petition_iOS.ViewController, SplashDisplayLogic {
    var interactor: SplashBusinessLogic?
    var router: (NSObject & SplashRoutingLogic & SplashDataPassing)?
    
    override func viewDidLoad() {
        //TODO
    }
}
