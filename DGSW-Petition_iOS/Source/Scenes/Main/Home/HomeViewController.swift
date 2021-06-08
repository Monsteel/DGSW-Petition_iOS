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
    func displayTopTenPetition(viewModel: Home.Refresh.ViewModel)
    func displayTopTenPetitionError(viewModel: Home.Refresh.ViewModel)
    
    func displayPetitionSituation(viewModel: Home.Refresh.ViewModel)
    func displayPetitionSituationError(viewModel: Home.Refresh.ViewModel)
    
    func displayWelcomeView(viewModel: Home.Refresh.ViewModel)
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

    var dataSource: HomeViewDataSource?
    
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
    
    private func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func onTabContainerView(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func addContainerViewTapEventHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTabContainerView))
        self.self.view.addGestureRecognizer(tap)
    }
      
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        addRefreshControl()
        addContainerViewTapEventHandler()
        
        dataSource = HomeViewDataSource(delegate: self)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        collectionView.reloadData()
        
        refresh()
    }
    
    // MARK: - request data from HomeInteractor

    @objc
    func refresh() {
        let request = Home.Refresh.Request()
        interactor?.refresh(request: request)
        collectionView.refreshControl?.endRefreshing()
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
    
    func displayTopTenPetition(viewModel: Home.Refresh.ViewModel) {
        let homeViewPetitionCellViewModel = viewModel.topTenPetitions?.map {
            HomeViewPetitionCell.ViewModel(idx: $0.idx, category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource?.updateData(homeViewPetitionCellViewModel: homeViewPetitionCellViewModel,
                               homeViewPetitionCellErrorMessage: nil,
                               delegate: self)
        collectionView.reloadData()
    }
    
    func displayPetitionSituation(viewModel: Home.Refresh.ViewModel) {
        let homeViewWidgetCellViewModel = viewModel.petitionSituation.map {
            HomeViewWidgetCell.ViewModel(agreeCount: $0.agreeCount, completedCount: $0.completedCount, awaitingCount: $0.awaitingCount)
        }
        
        dataSource?.updateData(homeViewWidgetCellViewModel: homeViewWidgetCellViewModel,
                               homeViewWidgetCellErrorMessage: nil,
                               delegate: self)
        
        collectionView.reloadData()
    }
    
    func displayTopTenPetitionError(viewModel: Home.Refresh.ViewModel) {
        dataSource?.updateData(homeViewWidgetCellViewModel: nil,
                               homeViewWidgetCellErrorMessage: viewModel.errorMessage,
                               delegate: self)
        
        collectionView.reloadData()
    }
    
    func displayPetitionSituationError(viewModel: Home.Refresh.ViewModel) {
        dataSource?.updateData(homeViewPetitionCellViewModel: nil,
                               homeViewPetitionCellErrorMessage: viewModel.errorMessage,
                               delegate: self)
        
        collectionView.reloadData()
    }
    
    func displayWelcomeView(viewModel: Home.Refresh.ViewModel) {
        //TODO: Rote To WelcomeView
    }
}

extension HomeViewController : HomeViewButtonWidgetCellDelegate, HomeViewPetitionCellDelegate, HomeViewSearchCellDelegate, HomeViewEmptyPetitionCellDelegate, HomeViewWidgetCellDelegate {
    func onClickRefreshButton() {
        refreshTopTenPetitions()
    }
    
    func onClickWritePetitionButton() {
        router?.routeToWritePetitionView()
    }
    
    func search(_ keyword: String) {
        if(keyword.isNotEmpty) {
            router?.routeToSearchView(keyword)
        }else{
            toastMessage("검색어를 입력 해 주세요", .warning)
        }
    }
        
    func onClickCell(viewModel: HomeViewPetitionCell.ViewModel) {
        router?.routeToDetailPetitionView(viewModel.idx)
    }
}
