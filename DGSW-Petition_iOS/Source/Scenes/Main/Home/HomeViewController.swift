//
//  HomeViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit

protocol HomeDisplayLogic: class
{
    func displaySomething(viewModel: Home.Something.ViewModel)
}

class HomeViewController: DGSW_Petition_iOS.ViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
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
    
    lazy var searchView = CardView().then {
        $0.cornerRadius = 10
        $0.borderWidth = 1.5
        $0.borderColor = .systemBlue
        $0.backgroundColor = .white
    }
    
    lazy var searchTextField = UITextField().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.font = .systemFont(ofSize: 16)
    }
    
    lazy var searchButton = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .systemBlue
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var imagebox = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
    }
    
    lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "petition_background_img")
        $0.contentMode = .scaleAspectFill
    }
    
    
    lazy var widgetStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    
    lazy var statusWidget = CardView().then {
        $0.cornerRadius = 15
        $0.backgroundColor = .white
        $0.borderColor = .systemGray4
        $0.borderWidth = 1
    }
    
    
    lazy var statusWidgetStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var agreeCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    
    lazy var statusCountStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    lazy var completedCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var awaitingCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var agreeCountTitleLabel = UILabel().then {
        $0.text = "누적 동의 수"
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    lazy var agreeCountLabel = UILabel().then {
        $0.text = "2154 명"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
    }
    
    lazy var completedCountTitleLabel = UILabel().then {
        $0.text = "답변 완료"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    lazy var completedCountLabel = UILabel().then {
        $0.text = "12 건"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
    }
    
    lazy var awaitingCountTitleLabel = UILabel().then {
        $0.text = "답변 대기"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    lazy var awaitingCountLabel = UILabel().then {
        $0.text = "6 건"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemOrange
        $0.textAlignment = .center
    }
    
    lazy var writePetitionBtnWidget = CardView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (onClickWritePetitionBtn)))
        $0.backgroundColor = .systemBlue
        $0.cornerRadius = 15
    }
    
    lazy var writePetitionBtnImage = UIImageView().then {
        $0.image = UIImage(systemName: "filemenu.and.cursorarrow")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var writePetitionBtnLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16.0)
        $0.textColor = .white
        $0.text = "청원 하기"
        $0.textAlignment = .center
    }
    
    
    func searchViewConstraintSettings() {
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchButton)
        
        view.addSubview(searchView)
        
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints {
            $0.left.equalTo(searchView).offset(10)
            $0.top.equalTo(searchView)
            $0.bottom.equalTo(searchView)
        }
        
        searchButton.snp.makeConstraints {
            $0.right.equalTo(searchView).offset(-15)
            $0.top.equalTo(searchView)
            $0.bottom.equalTo(searchView)
            $0.left.equalTo(searchTextField.snp.right)
            $0.width.equalTo(20)
        }
    }
    
    func imageBoxConstraintSettings() {
        imagebox.addSubview(imageView)
        view.addSubview(imagebox)
        
        imagebox.snp.makeConstraints {
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchView.snp.bottom).offset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(imagebox)
        }
    }

    
    func widgetViewConstraintSettings() {
        widgetStackView.addArrangedSubview(statusWidget)
        widgetStackView.addArrangedSubview(writePetitionBtnWidget)
        
        view.addSubview(widgetStackView)
        
        widgetStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.height.equalTo(100)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        statusWidget.snp.makeConstraints {
            $0.width.equalTo(widgetStackView).multipliedBy(0.485)
        }
        
        writePetitionBtnWidget.snp.makeConstraints {
            $0.width.equalTo(widgetStackView).multipliedBy(0.485)
        }
        
        statusWidgetConstraintSettings()
        
        writePetitionBtnWidgetConstraintSettings()
    }
    
    func statusWidgetConstraintSettings() {
        statusWidgetStackView.addArrangedSubview(agreeCountStackView)
        statusWidgetStackView.addArrangedSubview(statusCountStackView)
        statusCountStackView.addArrangedSubview(completedCountStackView)
        statusCountStackView.addArrangedSubview(awaitingCountStackView)
        
        statusWidget.addSubview(statusWidgetStackView)
        
        agreeCountStackView.addArrangedSubview(agreeCountTitleLabel)
        agreeCountStackView.addArrangedSubview(agreeCountLabel)
        
        completedCountStackView.addArrangedSubview(completedCountTitleLabel)
        completedCountStackView.addArrangedSubview(completedCountLabel)
        
        awaitingCountStackView.addArrangedSubview(awaitingCountTitleLabel)
        awaitingCountStackView.addArrangedSubview(awaitingCountLabel)
        
        
        
        statusWidgetStackView.snp.makeConstraints {
            $0.top.equalTo(statusWidget).offset(15)
            $0.bottom.equalTo(statusWidget).offset(-15)
            $0.left.equalTo(statusWidget).offset(15)
            $0.right.equalTo(statusWidget).offset(-15)
        }
        
        
        
        agreeCountStackView.snp.makeConstraints {
            $0.height.equalTo(statusWidgetStackView).multipliedBy(0.5)
        }
        
        statusCountStackView.snp.makeConstraints {
            $0.height.equalTo(statusWidgetStackView).multipliedBy(0.5)
        }
        
        completedCountStackView.snp.makeConstraints {
            $0.width.equalTo(statusCountStackView).multipliedBy(0.6)
        }
        
        awaitingCountStackView.snp.makeConstraints {
            $0.width.equalTo(statusCountStackView).multipliedBy(0.6)
        }
        
        
        
        agreeCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(agreeCountStackView).multipliedBy(0.4)
        }
        
        agreeCountLabel.snp.makeConstraints {
            $0.height.equalTo(agreeCountStackView).multipliedBy(0.6)
        }
        
        
        
        completedCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.6)
        }

        completedCountLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.5)
        }
        
        awaitingCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.6)
        }

        awaitingCountLabel.snp.makeConstraints {
            $0.height.equalTo(awaitingCountStackView).multipliedBy(0.5)
        }

        
    }
    
    func writePetitionBtnWidgetConstraintSettings() {
        writePetitionBtnWidget.addSubview(writePetitionBtnImage)
        writePetitionBtnWidget.addSubview(writePetitionBtnLabel)
        
        writePetitionBtnImage.snp.makeConstraints {
            $0.top.equalTo(writePetitionBtnWidget).offset(25)
            $0.left.equalTo(writePetitionBtnWidget).offset(60)
            $0.right.equalTo(writePetitionBtnWidget).offset(-60)
            $0.bottom.equalTo(writePetitionBtnLabel.snp.top).offset(-15)
        }
        
        writePetitionBtnLabel.snp.makeConstraints {
            $0.left.equalTo(writePetitionBtnWidget)
            $0.right.equalTo(writePetitionBtnWidget)
            $0.bottom.equalTo(writePetitionBtnWidget).offset(-15)
        }
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewConstraintSettings()
        imageBoxConstraintSettings()
        widgetViewConstraintSettings()
        
        doSomething()
    }
    
    //MARK: - receive events from UI
    
    @objc
    func onClickWritePetitionBtn() {
        //TODO: 청원작성View로 라우팅
        
    }
    
    
    // MARK: - request data from HomeInteractor

    func doSomething() {
        let request = Home.Something.Request()
        interactor?.doSomething(request: request)
    }

    // MARK: - display view model from HomePresenter

    func displaySomething(viewModel: Home.Something.ViewModel) {
        
    }
    
}
