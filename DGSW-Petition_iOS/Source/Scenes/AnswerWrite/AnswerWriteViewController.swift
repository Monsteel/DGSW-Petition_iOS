//
//  AnswerWriteViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/24.
//

import UIKit
import SnapKit

protocol AnswerWriteDisplayLogic: AnyObject
{
    func displayWriteAnswer(viewModel: AnswerWrite.WriteAnswer.ViewModel)
    func displayError(viewModel: AnswerWrite.WriteAnswer.ViewModel)
}

class AnswerWriteViewController: DGSW_Petition_iOS.UIViewController, AnswerWriteDisplayLogic, UIGestureRecognizerDelegate {
    var interactor: AnswerWriteBusinessLogic?
    var router: (NSObjectProtocol & AnswerWriteRoutingLogic & AnswerWriteDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = AnswerWriteInteractor()
        let presenter = AnswerWritePresenter()
        let router = AnswerWriteRouter()
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
    
    lazy var contentFieldContainer = CardView().then {
        $0.cornerRadius = 15
        $0.backgroundColor = .white
        $0.borderColor = .systemGray4
        $0.borderWidth = 1
    }
    
    lazy var contentField = UITextView().then {
        $0.font = .systemFont(ofSize: 14)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSettings(self, "답변 작성")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(onClickWriteButton))
        
        self.view.addSubview(contentFieldContainer)
        
        self.contentFieldContainer.addSubview(contentField)
        
        self.contentFieldContainer.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).offset(10).inset(10)
        }
        
        self.contentField.snp.makeConstraints {
            $0.edges.equalTo(self.contentFieldContainer).offset(10).inset(10)
        }
        
        addKeyboardNotification()
        contentField.becomeFirstResponder()
    }
    
    //MARK: - receive events from UI
    
    @objc
    func onClickWriteButton() {
        if(contentField.text == ""){
            return toastMessage("답변 내용을 입력해 주세요.", .warning)
        }
        
        if let targetPetitionIdx = router?.dataStore?.targetPetitionIdx {
            writeAnswer(petitionIdx: targetPetitionIdx, content: contentField.text)
        }else {
            return toastMessage("잘못된 답변 대상", .error)
        }
    }
    
    
    // MARK: - request data from AnswerWriteInteractor

    func writeAnswer(petitionIdx: Int, content: String) {
        let request = AnswerWrite.WriteAnswer.Request(petitionIdx: petitionIdx, content: content)
        interactor?.writeAnswer(request: request)
    }

    // MARK: - display view model from AnswerWritePresenter

    func displayWriteAnswer(viewModel: AnswerWrite.WriteAnswer.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            return toastMessage(errorMessage, .error)
        } else {
            toastMessage("답변 작성 완료", .success)
            router?.routeToPreviousView()
        }
    }
    
    func displayError(viewModel: AnswerWrite.WriteAnswer.ViewModel) {
        toastMessage(viewModel.errorMessage, .error)
    }
}

// MARK: - Keyboard notification
extension AnswerWriteViewController {
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
        self.contentFieldContainer.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-(newHeight+30))
        }
        super.updateViewConstraints()
        
        self.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    @objc private func keyboardWillHide(_ noti: Notification){
        
        UIView.setAnimationsEnabled(false)
        self.contentFieldContainer.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        super.updateViewConstraints()
        
        self.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}

