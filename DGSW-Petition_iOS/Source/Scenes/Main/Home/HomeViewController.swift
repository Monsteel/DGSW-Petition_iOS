//
//  HomeViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit
import Foundation

protocol HomeDisplayLogic: AnyObject
{
    func displaySomething(viewModel: Home.Something.ViewModel)
}

class HomeViewController: DGSW_Petition_iOS.UIViewController, HomeDisplayLogic {
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
    
    //MARK: - properties
    
    let dataSource = HomeViewDataSource(petitions: ["","","","","","","","","",""],
                       searchHandler: { _ in },
                       buttonWidgetClickHandler: { })

    // MARK: - UI
    
    lazy var layout = UICollectionViewFlowLayout()

    
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        .then { make in
            make.backgroundColor = .clear
            make.alwaysBounceVertical = true
            make.register(HomeViewSearchCell.self, forCellWithReuseIdentifier: HomeViewSearchCell.registerId)
            make.register(HomeViewBannerCell.self, forCellWithReuseIdentifier: HomeViewBannerCell.registerId)
            make.register(HomeViewWidgetCell.self, forCellWithReuseIdentifier: HomeViewWidgetCell.registerId)
            make.register(HomeViewButtonWidgetCell.self, forCellWithReuseIdentifier: HomeViewButtonWidgetCell.registerId)
            make.register(HomeViewPetitionCell.self, forCellWithReuseIdentifier: HomeViewPetitionCell.registerId)
            make.register(HomeViewPetitionHeader.self,
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: HomeViewPetitionHeader.registerId)
        }
  

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
        
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
