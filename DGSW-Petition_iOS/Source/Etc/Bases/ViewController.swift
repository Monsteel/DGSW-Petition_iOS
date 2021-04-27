//
//  ViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit
import Toast

class ViewController: UIViewController {
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /*
     * MUST OVERRIDE THIS METHOD
     */
    func setup() { }
    
    // MARK: Object lifecycle
    
    func toastMessage(_ message: String, _ position: ToastPosition = .bottom) -> Void {
        self.view.makeToast(message, duration: 3.0, position: position)
        return
    }
}
