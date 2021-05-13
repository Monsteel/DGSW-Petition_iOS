//
//  WindowManager.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit

final class WindowManager {
    
    private var window: UIWindow
    
    init(with window: UIWindow = UIWindow()) {
        self.window = window
    }
    
    convenience init(with scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        self.init(with: window)
    }
    
    func setRootViewController(_ controller: UIKit.UIViewController = UINavigationController(rootViewController: WelcomeViewController())) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
