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
        $0.font = .boldSystemFont(ofSize: 35)
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.text = "서비스 사용을 위해 회원가입을 진행합니다."
    }
    
//    lazy var title = UILabel().then {
//        $0.text = "회원가입 코드 입력"
//    }
//
//    lazy var descriptionLabel = UILabel().then {
//        $0.text = "학생 확인을 위해 가입 코드를 입력 해 주세요"
//    }
    
    lazy var registerCodeField = UITextField().then {
        $0.placeholder = "가입코드를 입력 해 주세요"
    }
    
    lazy var registerButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.backgroundColor = .systemBlue
        $0.addTarget(self, action: #selector(onTapRegisterButton), for: .touchUpInside)
    }
    
    // MARK: - View lifecycle

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(false)
        registerCodeField.becomeFirstResponder()
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(onTapBackButton))
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.barTintColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        self.view.addSubview(registerCodeField)
        self.view.addSubview(registerButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(20)
            $0.top.equalTo(view.snp.top).offset(90)
            $0.right.equalTo(view.snp.right).offset(10)
            $0.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalTo(titleLabel.snp.left).offset(2)
            $0.right.equalTo(view).offset(-20)
        }
        
        registerCodeField.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left).offset(2)
            $0.right.equalTo(view).offset(-30)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-30)
            $0.left.equalTo(view).offset(30)
            $0.right.equalTo(view).offset(-30)
            $0.height.equalTo(55)
        }
        
        registerCodeField.setNeedsFocusUpdate()
        addKeyboardNotification()
    }
    
    //MARK: - receive events from UI
    
    @objc
    func onTapRegisterButton() {
        guard let registerCode = registerCodeField.text else {
            return toastMessage("가입코드를 입력 해 주세요", .top)
        }
        
        if registerCode.isEmpty {
            return toastMessage("가입코드를 입력 해 주세요", .top)
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
            return toastMessage(errorMessage, .top)
        } else {
            router?.routeToWelcomeView(segue: nil)
        }
    }
}

// MARK: - Keyboard notification
extension RegisterViewController {
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keybordFrm = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        var safeBot: CGFloat = 0
        if let uBot = UIApplication.shared.windows.first?.safeAreaInsets.bottom { safeBot = uBot }
        let newHeight: CGFloat = keybordFrm.height - safeBot
        
        UIView.setAnimationsEnabled(false)
        print("키보드 올라옴")
        self.registerButton.snp.updateConstraints {
            $0.bottom.equalTo(view).offset(-(newHeight+60))
        }
        super.updateViewConstraints()
        
        self.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    @objc private func keyboardWillHide(_ noti: Notification){
        
        UIView.setAnimationsEnabled(false)
        self.registerButton.snp.updateConstraints {
            $0.bottom.equalTo(view).offset(-30)
        }
        super.updateViewConstraints()
        
        self.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
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