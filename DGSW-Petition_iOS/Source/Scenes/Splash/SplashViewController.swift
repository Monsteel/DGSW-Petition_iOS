//
//  SplashViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit
import SnapKit

class SplashViewController:DGSW_Petition_iOS.UIViewController {
    
    var isLoged: Bool {
        get {
            return KeychainManager.shared.accessToken?.isNotEmpty ?? false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkToken()
    }
    
    private func checkToken(){
        if (isLoged) {
            let destination = UINavigationController(rootViewController: MainViewController()).then {
                $0.modalPresentationStyle = .fullScreen
            }
            
            self.present(destination, animated: false)
        } else {
            let destination = UINavigationController(rootViewController: WelcomeViewController()).then {
                $0.modalPresentationStyle = .fullScreen
            }
            
            self.present(destination, animated: false)
        }
    }
}
