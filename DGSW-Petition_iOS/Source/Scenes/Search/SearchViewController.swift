//
//  SearchViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit
import SnapKit

protocol SearchDisplayLogic: class
{
    func displaySearchResult(viewModel: Search.Search.ViewModel)
    func displayLoadMoreResult(viewModel: Search.LoadMore.ViewModel)
}

class SearchViewController: DGSW_Petition_iOS.UIViewController, SearchDisplayLogic, UIGestureRecognizerDelegate {
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
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

    var dataSource: SearchViewDataSource? = nil
    
    // MARK: - UI
    
    lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        .then { make in
            make.backgroundColor = .clear
            make.alwaysBounceVertical = true
            make.register(SearchViewPetitionCell.self, forCellWithReuseIdentifier: SearchViewPetitionCell.registerId)
            make.register(SearchViewEmptyPetitionCell.self, forCellWithReuseIdentifier: SearchViewEmptyPetitionCell.registerId)
        }
  
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        self.navigationBarSettings(self, "'\(router?.dataStore?.searchKeyword ?? "")' 검색 결과")
        
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.search()
    }
    
    //MARK: - receive events from UI
    
    
    
    // MARK: - request data from SearchInteractor

    func search() {
        let request = Search.Search.Request()
        interactor?.search(request: request)
    }
    
    func loadMore(page: Int) {
        let request = Search.LoadMore.Request(page: page)
        interactor?.loadMore(request: request)
    }

    // MARK: - display view model from SearchPresenter

    func displaySearchResult(viewModel: Search.Search.ViewModel) {
        let searchViewPetitionCellViewModel = viewModel.petitions?.map {
            SearchViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource = SearchViewDataSource(delegate: self,
                                          searchViewPetitionCellViewModel: searchViewPetitionCellViewModel,
                                          errorMessage: viewModel.errorMessage,
                                          searchKeyword: router?.dataStore?.searchKeyword ?? "")
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        collectionView.reloadData()
    }
    
    func displayLoadMoreResult(viewModel: Search.LoadMore.ViewModel) {
        dataSource?.isLoadingMore = false
        let searchViewPetitionCellViewModel = viewModel.petitions.map {
            SearchViewPetitionCell.ViewModel(category: $0.category, title: $0.title, expirationDate: $0.expirationDate, agreeCount: $0.agreeCount)
        }
        
        dataSource?.loadMore(delegate: self,
                             searchViewPetitionCellViewModel: searchViewPetitionCellViewModel)
        
        collectionView.reloadData()
    }
}


extension SearchViewController: SearchViewPetitionCellDelegate, SearchViewDataSourceDelegate {
    func onClickCell(viewMdoel: SearchViewPetitionCell.ViewModel) {
        //TODO
    }
    
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
}
