//
//  RegisterViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/22.
//

import UIKit
import SnapKit

protocol RegisterDisplayLogic: class {
    func displayRegister(viewModel: Register.Register.ViewModel)
}

class RegisterViewController: DGSW_Petition_iOS.ViewController, RegisterDisplayLogic {
    var interactor: RegisterBusinessLogic?
    var router: (NSObjectProtocol & RegisterRoutingLogic & RegisterDataPassing)?

    // MARK: - Setup Clean Code Design Pattern

    override func setup() {
        let viewController = self
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let router = RegisterRouter()
        
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

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - receive events from UI

    
    
    // MARK: - request data from RegisterInteractor

    func register(permissionKey: String,
                  userID: String,
                  googleToken: String) {
        let request = Register.Register.Request(permissionKey: permissionKey,
                                                userID: userID,
                                                googleToken: googleToken)
        interactor?.register(request: request)
    }

    // MARK: - display view model from RegisterPresenter

    func displayRegister(viewModel: Register.Register.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            return toastMessage(errorMessage)
        } else {
            // TODO: - Login View로 라우팅 처리
            return toastMessage("가입 성공")
        }
    }
}

//#if DEBUG
//import SwiftUI
//
//@available(iOS 13, *)
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        // view controller using programmatic UI
//        Group {
//            RegisterViewController().showPreview()
//        }
//    }
//}
//#endif
