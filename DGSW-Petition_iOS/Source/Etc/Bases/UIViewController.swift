//
//  UIViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

import UIKit
import Toast
import Tabman
import SwiftMessages

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
    
    func toastMessage(_ message: String?, _ theme: Theme = .info) -> Void {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.defaultConfig
        
        view.configureContent(title: nil,
                              body: message,
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: nil,
                              buttonTitle: nil,
                              buttonTapHandler: { _ in SwiftMessages.hide() })
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true
        view.configureTheme(theme)
        view.configureDropShadow()
        
        config.dimMode = .gray(interactive: true)
        config.presentationStyle = .bottom
        config.presentationContext = .automatic
        config.duration = .seconds(seconds: 2)
        
        SwiftMessages.show(config: config, view: view)
        return
    }
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setLoadingView()
    }
    
    lazy var indicator = UIActivityIndicatorView()
    
    private func setLoadingView(){
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(50)
            $0.center.equalToSuperview()
        }
        indicator.isHidden = true
    }
    
    func startLoading(){
        self.view.bringSubviewToFront(indicator)
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func stopLoading(){
        indicator.isHidden = true
        indicator.stopAnimating()
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
                $0.font = .boldSystemFont(ofSize: 16)
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
    
    func warningAlert(title: String?, message: String, handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:  handler))
        self.present(alert, animated: true, completion: nil)
    }
}
