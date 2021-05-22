//
//  UIViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit
import Toast
import Tabman

class UIViewController: UIKit.UIViewController {
    
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
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        self.view.backgroundColor = .white
    }
    
    // MARK: - [Navigation Bar + Navigation Item] Settings
    
    private func navigationBarSettings() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func navigationBarSettings(_ gestureDelegate: UIGestureRecognizerDelegate, _ titleText: String?, _ isHideDivider: Bool = false) {
        navigationBarSettings()
        
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = gestureDelegate
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(onTapBackButton))

        self.navigationController?.navigationBar.sizeToFit()
        
        if(titleText != nil) {
            navigationItem.titleView = UILabel().then {
                $0.text = titleText
                $0.font = .boldSystemFont(ofSize: 14)
            }
        }
        
        if (isHideDivider) {
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }else {
            self.navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    func navigationBarSettings(_ isHideDivider: Bool = false) {
        navigationBarSettings()
        if (isHideDivider) {
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }else {
            self.navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    @objc
    func onTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}