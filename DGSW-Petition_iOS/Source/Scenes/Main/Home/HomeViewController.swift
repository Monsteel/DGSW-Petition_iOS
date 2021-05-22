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
    func displayInitialView(viewModel: Home.Refresh.ViewModel)
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

    var dataSource: HomeViewDataSource? = nil
    
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
            make.register(HomeViewEmptyPetitionCell.self, forCellWithReuseIdentifier: HomeViewEmptyPetitionCell.registerId)
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
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        refresh()
    }
    
    // MARK: - request data from HomeInteractor

    func refresh() {
        let request = Home.Refresh.Request()
        interactor?.refresh(request: request)
    }
    
    func refreshTopTenPetitions(){
        let request = Home.Refresh.Request()
        interactor?.refresh(request: request)
    }
    
    func refreshPetitionsSituations(){
        let request = Home.Refresh.Request()
        interactor?.refresh(request: request)
    }

    // MARK: - display view model from HomePresenter
    func displayInitialView(viewModel: Home.Refresh.ViewModel) {
        let homeViewWidgetCellViewModel = viewModel.petitionSituation.map {
            HomeViewWidgetCell.ViewModel(agreeCount: $0.agreeCount, completedCount: $0.completedCount, awaitingCount: $0.awaitingCount)
        }
        
        let homeViewPetitionCellViewModel = viewModel.topTenPetitions?.map {
            HomeViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource = HomeViewDataSource(delegate: self,
                                        homeViewWidgetCellViewModel: homeViewWidgetCellViewModel,
                                        homeViewPetitionCellViewModel: homeViewPetitionCellViewModel,
                                        homeViewWidgetCellErrorMessage: viewModel.petitionSituationErrorMessage,
                                        homeViewPetitionCellErrorMessage: viewModel.topTenPetitionErrorMessage)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        collectionView.reloadData()
    }
}

extension HomeViewController : HomeViewButtonWidgetCellDelegate, HomeViewPetitionCellDelegate, HomeViewSearchCellDelegate, HomeViewEmptyPetitionCellDelegate, HomeViewWidgetCellDelegate {
    func onClickRefreshButton() {
        refreshTopTenPetitions()
    }
    
    func onClickWritePetitionButton() {
        //TODO: Route To Write Petition VC
    }
    
    func search(_ keyword: String) {
        //TODO: Route To Search VC
    }
        
    func onClickCell(viewMdoel: HomeViewPetitionCell.ViewModel) {
        //TODO: Route To Petition Info VC
    }
}
