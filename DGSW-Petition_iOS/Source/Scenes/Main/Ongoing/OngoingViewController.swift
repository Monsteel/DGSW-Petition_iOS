//
//  OngoingViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit

protocol OngoingDisplayLogic: AnyObject
{
    func displayInitialView(viewModel: Ongoing.Refresh.ViewModel)
    func displayLoadMoreView(viewModel: Ongoing.LoadMore.ViewModel)
}

class OngoingViewController: DGSW_Petition_iOS.UIViewController, OngoingDisplayLogic {
    var interactor: OngoingBusinessLogic?
    var router: (NSObjectProtocol & OngoingRoutingLogic & OngoingDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = OngoingInteractor()
        let presenter = OngoingPresenter()
        let router = OngoingRouter()
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

    var dataSource: OngoingViewDataSource? = nil
    
    // MARK: - UI
    
    lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        .then { make in
            make.backgroundColor = .clear
            make.alwaysBounceVertical = true
            make.register(OngoingViewPetitionCell.self, forCellWithReuseIdentifier: OngoingViewPetitionCell.registerId)
            make.register(OngoingViewEmptyPetitionCell.self, forCellWithReuseIdentifier: OngoingViewEmptyPetitionCell.registerId)
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
    
    //MARK: - receive events from UI
    
    
    // MARK: - request data from OngoingInteractor

    func refresh() {
        let request = Ongoing.Refresh.Request()
        interactor?.refresh(request: request)
    }
    
    /// OngoingViewDataSourceDelegate Impl method
    func loadMore(page: Int) {
        let request = Ongoing.LoadMore.Request(page: page)
        interactor?.loadMore(request: request)
    }

    // MARK: - display view model from OngoingPresenter

    func displayInitialView(viewModel: Ongoing.Refresh.ViewModel) {
        let ongoingViewPetitionCellViewModel = viewModel.petitions?.map {
            OngoingViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource = OngoingViewDataSource(delegate: self,
                                           ongoingViewPetitionCellViewModel: ongoingViewPetitionCellViewModel,
                                           ongoingViewPetitionCellErrorMessage: viewModel.errorMessage)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        collectionView.reloadData()
    }
    
    func displayLoadMoreView(viewModel: Ongoing.LoadMore.ViewModel) {
        dataSource?.isLoadingMore = false
        let ongoingViewPetitionCellViewModel = viewModel.petitions.map {
            OngoingViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource?.loadMore(delegate: self,
                             ongoingViewPetitionCellViewModel: ongoingViewPetitionCellViewModel)
        
        collectionView.reloadData()
    }
}

extension OngoingViewController: OngoingViewPetitionCellDelegate, OngoingViewEmptyPetitionCellDelegate, OngoingViewDataSourceDelegate {
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
    
    func onClickCell(viewMdoel: OngoingViewPetitionCell.ViewModel) {
        //TODO: Route To Petition Info VC
    }
    
    func onClickRefreshButton() {
        //TODO: RefreshView
    }
    
    func onClickWritePetitionButton() {
        //TODO: Route To Write Petition VC
    }    
}
