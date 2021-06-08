//
//  UITextField.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/03.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
