//
//  ViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit
import Toast

class ViewController: UIViewController {
    func toastMessage(_ message: String) -> Void {
        self.view.makeToast(message, duration: 3.0, position: .bottom)
        return
    }
}
