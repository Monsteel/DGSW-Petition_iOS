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

class RegisterViewController: DGSW_Petition_iOS.ViewController, RegisterDisplayLogic, UIGestureRecognizerDelegate {
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
    
    // MARK: - UI
    
    lazy var titleLabel = UILabel().then {
        $0.text = "안녕하세요 :)"
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.text = "DGSW학생청원 사용을 위해 회원가입을 진행합니다."
    }
    
//    lazy var title = UILabel().then {
//        $0.text = "회원가입 코드 입력"
//    }
//
//    lazy var descriptionLabel = UILabel().then {
//        $0.text = "학생 확인을 위해 가입 코드를 입력 해 주세요"
//    }
    
    lazy var registerCodeField = UITextField().then {
        $0.backgroundColor = .green
    }
    
    lazy var registerButton = UIButton().then {
        $0.backgroundColor = .blue
        $0.addTarget(self, action: #selector(onTapRegisterButton), for: .touchUpInside)
    }
    
    // MARK: - View lifecycle

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(onTapBackButton))
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.titleView = UITextView().then {
            $0.text = "타이틀"
            $0.font = UIFont(name: "", size: 12.0)
            $0.backgroundColor = .none
        }
        
        self.view.addSubview(registerCodeField)
        self.view.addSubview(registerButton)
        
        registerCodeField.snp.makeConstraints {
            $0.bottom.equalTo(registerButton).offset(-200)
            $0.left.equalTo(view).offset(30)
            $0.right.equalTo(view).offset(-30)
            $0.height.equalTo(75)
        }
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-300)
            $0.left.equalTo(view).offset(30)
            $0.right.equalTo(view).offset(-30)
            $0.height.equalTo(75)
        }
    }
    
    //MARK: - receive events from UI
    
    @objc
    func onTapRegisterButton() {
        guard let registerCode = registerCodeField.text else {
            return toastMessage("가입코드를 입력 해 주세요")
        }
        
        if registerCode.isEmpty {
            return toastMessage("가입코드를 입력 해 주세요")
        }
        
        register(permissionKey: registerCode)
    }
    
    @objc
    func onTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - request data from RegisterInteractor

    func register(permissionKey: String) {
        let request = Register.Register.Request(permissionKey: permissionKey)
        interactor?.register(request: request)
    }

    // MARK: - display view model from RegisterPresenter

    func displayRegister(viewModel: Register.Register.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            return toastMessage(errorMessage)
        } else {
            router?.routeToWelcomeView(segue: nil)
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
            RegisterViewController().showPreview()
        }
    }
}
#endif
