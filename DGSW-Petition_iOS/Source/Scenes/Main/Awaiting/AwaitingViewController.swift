//
//  AwaitingViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit

protocol AwaitingDisplayLogic: AnyObject
{
    func displayInitialView(viewModel: Awaiting.Refresh.ViewModel)
    func displayLoadMoreView(viewModel: Awaiting.LoadMore.ViewModel)
}

class AwaitingViewController: DGSW_Petition_iOS.UIViewController, AwaitingDisplayLogic {
    var interactor: AwaitingBusinessLogic?
    var router: (NSObjectProtocol & AwaitingRoutingLogic & AwaitingDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = AwaitingInteractor()
        let presenter = AwaitingPresenter()
        let router = AwaitingRouter()
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

    var dataSource: AwaitingViewDataSource? = nil
    
    // MARK: - UI
    
    lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        .then { make in
            make.backgroundColor = .clear
            make.alwaysBounceVertical = true
            make.register(AwaitingViewPetitionCell.self, forCellWithReuseIdentifier: AwaitingViewPetitionCell.registerId)
            make.register(AwaitingViewEmptyPetitionCell.self, forCellWithReuseIdentifier: AwaitingViewEmptyPetitionCell.registerId)
        }
    
    private func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        addRefreshControl()
        refresh()
        startLoading()
    }
    
    //MARK: - receive events from UI
    
    
    // MARK: - request data from AwaitingInteractor

    @objc
    func refresh() {
        let request = Awaiting.Refresh.Request()
        interactor?.refresh(request: request)
        collectionView.refreshControl?.endRefreshing()
    }
    
    /// AwaitingViewDataSourceDelegate Impl method
    func loadMore(page: Int) {
        let request = Awaiting.LoadMore.Request(page: page)
        interactor?.loadMore(request: request)
    }

    // MARK: - display view model from AwaitingPresenter

    func displayInitialView(viewModel: Awaiting.Refresh.ViewModel) {
        let awaitingViewPetitionCellViewModel = viewModel.petitions?.map {
            AwaitingViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource = AwaitingViewDataSource(delegate: self,
                                           awaitingViewPetitionCellViewModel: awaitingViewPetitionCellViewModel,
                                           awaitingViewPetitionCellErrorMessage: viewModel.errorMessage)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        collectionView.reloadData().self
        
        self.collectionView.isHidden = false
        stopLoading()
    }
    
    func displayLoadMoreView(viewModel: Awaiting.LoadMore.ViewModel) {
        dataSource?.isLoadingMore = false
        let awaitingViewPetitionCellViewModel = viewModel.petitions.map {
            AwaitingViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource?.loadMore(delegate: self,
                             awaitingViewPetitionCellViewModel: awaitingViewPetitionCellViewModel)
        
        collectionView.reloadData()
    }
}

extension AwaitingViewController: AwaitingViewPetitionCellDelegate, AwaitingViewEmptyPetitionCellDelegate, AwaitingViewDataSourceDelegate {
    var isScrolledToBottomWithBuffer: Bool {
        let buffer = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        let maxVisibleY = collectionView.contentOffset.y + self.collectionView.bounds.size.height
        let actualMaxY = collectionView.contentSize.height + collectionView.contentInset.bottom
        return maxVisibleY + buffer >= actualMaxY
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentSize.height == 0) { return }
        if !(dataSource?.isLoadingMore ?? true), isScrolledToBottomWithBuffer, !(dataSource?.isFinishLoad ?? true){
            dataSource?.isLoadingMore = true
            self.loadMore(page: (dataSource?.currentPageCount ?? 0) + 1)
        }
    }
    
    func onClickCell(viewMdoel: AwaitingViewPetitionCell.ViewModel) {
        //TODO: Route To Petition Info VC
    }
    
    func onClickRefreshButton() {
        refresh()
    }
    
    func onClickWritePetitionButton() {
        router?.routeToWritePetitionView()
    }
}
