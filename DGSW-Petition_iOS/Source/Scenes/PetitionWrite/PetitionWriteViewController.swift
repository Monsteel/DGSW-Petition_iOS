//
//  PetitionWriteViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit
import SnapKit

protocol PetitionWriteDisplayLogic: class
{
    func displayPetitionInfo(viewModel: PetitionWrite.Refresh.ViewModel)
    func displayWriteResult(viewModel: PetitionWrite.WritePetition.ViewModel)
    func displayModifyResult(viewModel: PetitionWrite.ModifyPetition.ViewModel)
}

class PetitionWriteViewController: DGSW_Petition_iOS.UIViewController, PetitionWriteDisplayLogic, UIGestureRecognizerDelegate {
    var interactor: PetitionWriteBusinessLogic?
    var router: (NSObjectProtocol & PetitionWriteRoutingLogic & PetitionWriteDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = PetitionWriteInteractor()
        let presenter = PetitionWritePresenter()
        let router = PetitionWriteRouter()
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
    
    let scrollView = UIScrollView()
    let contentView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let categoryContainer = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "카테고리"
        $0.textAlignment = .center
    }
    let categoryCardView = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.roundCorner = true
        $0.backgroundColor = .white
    }
    let categoryFieldLabel = UILabel().then {
        $0.text = "선택하세요"
        $0.textColor = .placeholderText
        $0.font = .systemFont(ofSize: 16)
    }
    
    let titleContainer = UIView()
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "제목"
        $0.textAlignment = .center
    }
    let titleCardView = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.roundCorner = true
        $0.backgroundColor = .white
    }
    let titleField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let contentContainer = UIView().then {
        $0.backgroundColor = .white
    }
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "내용"
        $0.textAlignment = .center
    }
    let contentCardView = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.roundCorner = true
        $0.backgroundColor = .white
    }
    let contentField = UITextView().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let firstKeywordContainer = UIView().then {
        $0.backgroundColor = .white
    }
    let firstKeywordLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "검색태그1"
        $0.textAlignment = .center
    }
    let firstKeywordCardView = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.roundCorner = true
        $0.backgroundColor = .white
    }
    let firstKeywordField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.placeholder = "선택사항"
    }
    
    let secondKeywordContainer = UIView().then {
        $0.backgroundColor = .white
    }
    let secondKeywordLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "검색태그2"
        $0.textAlignment = .center
    }
    let secondKeywordCardView = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.roundCorner = true
        $0.backgroundColor = .white
    }
    let secondKeywordField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.placeholder = "선택사항"
    }
    
    let thirdKeywordContainer = UIView().then {
        $0.backgroundColor = .white
    }
    let thirdKeywordLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "검색태그3"
        $0.textAlignment = .center
    }
    let thirdKeywordCardView = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.roundCorner = true
        $0.backgroundColor = .white
    }
    let thirdKeywordField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.placeholder = "선택사항"
    }
    
    private func setCategoryFieldLabel(_ text: String) {
        self.categoryFieldLabel.textColor = .black
        self.categoryFieldLabel.text = text
    }
    
    private func addCategoryContainerTapEventHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTabCategoryContainer))
        self.categoryContainer.addGestureRecognizer(tap)
    }
    
    private func addContainerViewTapEventHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTabContainerView))
        self.scrollView.addGestureRecognizer(tap)
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardNotification()
        addContainerViewTapEventHandler()
        addCategoryContainerTapEventHandler()
        
        navigationBarSettings(self, "청원 게시글 작성")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(onClickWriteButton))
        
        self.view.isUserInteractionEnabled = true
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        
        
        contentView.addArrangedSubview(categoryContainer)
        categoryContainer.addSubview(categoryLabel)
        categoryContainer.addSubview(categoryCardView)
        categoryContainer.addSubview(categoryFieldLabel)
        
        categoryContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryContainer)
            $0.left.equalTo(categoryContainer).inset(20)
            $0.width.equalTo(70)
        }
        
        categoryCardView.snp.makeConstraints {
            $0.centerY.equalTo(categoryContainer)
            $0.left.equalTo(categoryLabel.snp.right).offset(20)
            $0.right.equalTo(categoryContainer).offset(-20)
            $0.height.equalTo(40)
        }
        
        categoryFieldLabel.snp.makeConstraints {
            $0.edges.equalTo(categoryCardView).offset(10).inset(10)
        }
        
        
        
        contentView.addArrangedSubview(titleContainer)
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(titleCardView)
        titleCardView.addSubview(titleField)
        
        titleContainer.snp.makeConstraints {
            $0.top.equalTo(categoryContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleContainer)
            $0.left.equalTo(titleContainer).inset(20)
            $0.width.equalTo(70)
        }
        
        titleCardView.snp.makeConstraints {
            $0.centerY.equalTo(titleContainer)
            $0.left.equalTo(titleLabel.snp.right).offset(20)
            $0.right.equalTo(titleContainer).offset(-20)
            $0.height.equalTo(40)
        }
        
        titleField.snp.makeConstraints {
            $0.edges.equalTo(titleCardView).offset(10).inset(10)
        }
        
        
        contentView.addArrangedSubview(contentContainer)
        contentContainer.addSubview(contentLabel)
        contentContainer.addSubview(contentCardView)
        contentCardView.addSubview(contentField)
        
        contentContainer.snp.makeConstraints {
            $0.top.equalTo(titleContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentContainer)
            $0.left.equalTo(contentContainer).inset(20)
            $0.width.equalTo(70)
        }
        
        contentCardView.snp.makeConstraints {
            $0.centerY.equalTo(contentContainer)
            $0.left.equalTo(contentLabel.snp.right).offset(20)
            $0.right.equalTo(contentContainer).offset(-20)
            $0.height.equalTo(295)
        }
        
        contentField.snp.makeConstraints {
            $0.edges.equalTo(contentCardView).offset(10).inset(10)
        }
        

        contentView.addArrangedSubview(firstKeywordContainer)
        firstKeywordContainer.addSubview(firstKeywordLabel)
        firstKeywordContainer.addSubview(firstKeywordCardView)
        firstKeywordCardView.addSubview(firstKeywordField)

        firstKeywordContainer.snp.makeConstraints {
            $0.top.equalTo(contentContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }

        firstKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(firstKeywordContainer)
            $0.left.equalTo(firstKeywordContainer).inset(20)
            $0.width.equalTo(70)
        }

        firstKeywordCardView.snp.makeConstraints {
            $0.centerY.equalTo(firstKeywordContainer)
            $0.left.equalTo(firstKeywordLabel.snp.right).offset(20)
            $0.right.equalTo(firstKeywordContainer).offset(-20)
            $0.height.equalTo(40)
        }

        firstKeywordField.snp.makeConstraints {
            $0.edges.equalTo(firstKeywordCardView).offset(10).inset(10)
        }
        
        
        contentView.addArrangedSubview(secondKeywordContainer)
        secondKeywordContainer.addSubview(secondKeywordLabel)
        secondKeywordContainer.addSubview(secondKeywordCardView)
        secondKeywordCardView.addSubview(secondKeywordField)

        secondKeywordContainer.snp.makeConstraints {
            $0.top.equalTo(firstKeywordContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }

        secondKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(secondKeywordContainer)
            $0.left.equalTo(secondKeywordContainer).inset(20)
            $0.width.equalTo(70)
        }

        secondKeywordCardView.snp.makeConstraints {
            $0.centerY.equalTo(secondKeywordContainer)
            $0.left.equalTo(secondKeywordLabel.snp.right).offset(20)
            $0.right.equalTo(secondKeywordContainer).offset(-20)
            $0.height.equalTo(40)
        }

        secondKeywordField.snp.makeConstraints {
            $0.edges.equalTo(secondKeywordCardView).offset(10).inset(10)
        }


        contentView.addArrangedSubview(thirdKeywordContainer)
        thirdKeywordContainer.addSubview(thirdKeywordLabel)
        thirdKeywordContainer.addSubview(thirdKeywordCardView)
        thirdKeywordCardView.addSubview(thirdKeywordField)

        thirdKeywordContainer.snp.makeConstraints {
            $0.top.equalTo(secondKeywordLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview()
        }

        thirdKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(thirdKeywordContainer)
            $0.left.equalTo(thirdKeywordContainer).inset(20)
            $0.width.equalTo(70)
        }

        thirdKeywordCardView.snp.makeConstraints {
            $0.centerY.equalTo(thirdKeywordContainer)
            $0.left.equalTo(thirdKeywordLabel.snp.right).offset(20)
            $0.right.equalTo(thirdKeywordContainer).offset(-20)
            $0.height.equalTo(40)
        }

        thirdKeywordField.snp.makeConstraints {
            $0.edges.equalTo(thirdKeywordCardView).offset(10).inset(10)
        }
        
        if(router?.dataStore?.idx != nil){ refresh() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let categoryName = router?.dataStore?.categoryName else { return }
        setCategoryFieldLabel(categoryName)
    }
    
    //MARK: - receive events from UI
    
    @objc
    private func onTabContainerView(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc
    private func onTabCategoryContainer(recognizer: UITapGestureRecognizer) {
        router?.routeToCategoryPickerView()
    }
    
    @objc
    func onClickWriteButton() {
        if((titleField.text?.isEmpty ?? true) || (contentField.text?.isEmpty ?? true) || (router?.dataStore?.categoryIdx == nil)) {
            return toastMessage("내용을 모두 작성해 주세요", .top)
        }
        
        if(router?.dataStore?.idx == nil){ write() }
        else { modify() }
    }
    
    // MARK: - request data from PetitionWriteInteractor

    func refresh() {
        let request = PetitionWrite.Refresh.Request()
        interactor?.refresh(request: request)
    }
    
    func write() {
        let request = PetitionWrite.WritePetition.Request(title: titleField.text ?? "",
                                                          content: contentField.text ?? "",
                                                          fkeyword: firstKeywordField.text ?? "",
                                                          skeyword: secondKeywordField.text ?? "",
                                                          tkeyword: thirdKeywordField.text ?? "")
        interactor?.writePetition(request: request)
    }
    
    func modify() {
        let request = PetitionWrite.ModifyPetition.Request(title: titleField.text ?? "",
                                                           content: contentField.text ?? "",
                                                           fkeyword: firstKeywordField.text ?? "",
                                                           skeyword: secondKeywordField.text ?? "",
                                                           tkeyword: thirdKeywordField.text ?? "")
        interactor?.modifyPetition(request: request)
    }

    // MARK: - display view model from PetitionWritePresenter

    func displayPetitionInfo(viewModel: PetitionWrite.Refresh.ViewModel) {
        guard let petition = viewModel.petition else { return }
        
        titleField.text = petition.title
        contentField.text = petition.content
        categoryFieldLabel.text = petition.categoryName
        firstKeywordField.text = petition.fKeyword
        secondKeywordField.text = petition.sKeyword
        thirdKeywordField.text = petition.tKeyword
    }
    
    func displayWriteResult(viewModel: PetitionWrite.WritePetition.ViewModel) {
        
        if let errorMessage = viewModel.errorMessage {
            toastMessage(errorMessage)
        }else {
            toastMessage("청원 작성 완료")
            router?.routeToPreviousView()
        }
        
    }
    
    func displayModifyResult(viewModel: PetitionWrite.ModifyPetition.ViewModel) {
        
        if let errorMessage = viewModel.errorMessage {
            toastMessage(errorMessage)
        }else {
            toastMessage("청원 수정 완료")
            router?.routeToPreviousView()
        }
        
    }
}

// MARK: - Keyboard notification
extension PetitionWriteViewController {
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHide(_ noti: Notification){
        let contentInset = UIEdgeInsets.zero
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}
