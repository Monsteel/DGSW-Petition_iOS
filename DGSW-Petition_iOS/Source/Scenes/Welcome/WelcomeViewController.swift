//
//  WelcomeViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Then
import SnapKit
import GoogleSignIn

protocol WelcomeDisplayLogic: class {
    func displayCheckRegisteredUser(viewModel: Welcome.CheckRegisteredUser.ViewModel)
    func displayLogin(viewModel: Welcome.Login.ViewModel)
}

class WelcomeViewController: DGSW_Petition_iOS.ViewController, WelcomeDisplayLogic, GIDSignInDelegate {
    var interactor: WelcomeBusinessLogic?
    var router: (NSObjectProtocol & WelcomeRoutingLogic & WelcomeDataPassing)?
    var user: GIDGoogleUser?
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup Clean Code Design Pattern

    private func setup() {
        let viewController = self
        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter()
        let router = WelcomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - UI
    
    var signInButton = GIDSignInButton().then {
        $0.style = .wide
    }
    
    lazy var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "welcomeViewBackgroundImage")
        $0.contentMode = .scaleAspectFill
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-50)
            $0.left.equalTo(view).offset(30)
            $0.right.equalTo(view).offset(-30)
            $0.height.equalTo(75)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - receive events from UI
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                toastMessage("로그인이 취소되었거나, 로그아웃되었습니다 :(")
            } else {
                toastMessage(error.localizedDescription)
            }
            return
        }
        self.user = user
        
        guard let userID = self.user?.userID else {
            return toastMessage("오류가 발생했습니다 :(")
        }
        
        checkRegisteredUser(userID: userID)
    }
    
    // MARK: - request data from WelcomeInteractor

    func login(userID: String, googleToken: String) {
        interactor?.login(request: Welcome.Login.Request(userID: userID, googleToken: googleToken))
    }
    
    func checkRegisteredUser(userID: String){
        interactor?.checkRegisteredUser(request: Welcome.CheckRegisteredUser.Request(userID: userID))
    }

    // MARK: - display view model from WelcomePresenter

    func displayLogin(viewModel: Welcome.Login.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            return toastMessage(errorMessage)
        } else {
            // TODO: - Home View로 라우팅 처리
            return toastMessage("로그인 성공")
        }
    }
    
    func displayCheckRegisteredUser(viewModel: Welcome.CheckRegisteredUser.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            return toastMessage(errorMessage)
        }
        
        if(viewModel.isRegistered) {
            guard let userID = self.user?.userID,
                  let idToken = self.user?.authentication.idToken else {
                return toastMessage("오류가 발생했습니다 :(")
            }
            login(userID: userID, googleToken: idToken)
        }else{
            // TODO: - Register View로 라우팅 처리
            return toastMessage("회원가입 필요")
        }
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            WelcomeViewController().showPreview()
        }
    }
}
#endif
