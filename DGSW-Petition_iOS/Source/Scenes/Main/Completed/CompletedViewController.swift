//
//  CompletedViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit

protocol CompletedDisplayLogic: class
{
    func displayInitialView(viewModel: Completed.Refresh.ViewModel)
    func displayLoadMoreView(viewModel: Completed.LoadMore.ViewModel)
}

class CompletedViewController: DGSW_Petition_iOS.UIViewController, CompletedDisplayLogic {
    var interactor: CompletedBusinessLogic?
    var router: (NSObjectProtocol & CompletedRoutingLogic & CompletedDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = CompletedInteractor()
        let presenter = CompletedPresenter()
        let router = CompletedRouter()
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

    var dataSource: CompletedViewDataSource? = nil
    
    // MARK: - UI
    
    lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        .then { make in
            make.backgroundColor = .clear
            make.alwaysBounceVertical = true
            make.register(CompletedViewPetitionCell.self, forCellWithReuseIdentifier: CompletedViewPetitionCell.registerId)
            make.register(CompletedViewEmptyPetitionCell.self, forCellWithReuseIdentifier: CompletedViewEmptyPetitionCell.registerId)
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
    
    
    // MARK: - request data from CompletedInteractor

    func refresh() {
        let request = Completed.Refresh.Request()
        interactor?.refresh(request: request)
    }
    
    /// CompletedViewDataSourceDelegate Impl method
    func loadMore(page: Int) {
        let request = Completed.LoadMore.Request(page: page)
        interactor?.loadMore(request: request)
    }

    // MARK: - display view model from CompletedPresenter

    func displayInitialView(viewModel: Completed.Refresh.ViewModel) {
        let completedViewPetitionCellViewModel = viewModel.petitions?.map {
            CompletedViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource = CompletedViewDataSource(delegate: self,
                                             completedViewPetitionCellViewModel: completedViewPetitionCellViewModel,
                                             completedViewPetitionCellErrorMessage: viewModel.errorMessage)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        collectionView.reloadData()
    }
    
    func displayLoadMoreView(viewModel: Completed.LoadMore.ViewModel) {
        dataSource?.isLoadingMore = false
        let completedViewPetitionCellViewModel = viewModel.petitions.map {
            CompletedViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource?.loadMore(delegate: self,
                             completedViewPetitionCellViewModel: completedViewPetitionCellViewModel)
        
        collectionView.reloadData()
    }
}

extension CompletedViewController: CompletedViewPetitionCellDelegate, CompletedViewEmptyPetitionCellDelegate, CompletedViewDataSourceDelegate {
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
    
    func onClickCell(viewMdoel: CompletedViewPetitionCell.ViewModel) {
        //TODO: Route To Petition Info VC
    }
    
    func onClickRefreshButton() {
        //TODO: RefreshView
    }
    
    func onClickWritePetitionButton() {
        //TODO: Route To Write Petition VC
    }
}
