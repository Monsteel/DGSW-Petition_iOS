//
//  CategoryPickerViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit
import SnapKit

protocol CategoryPickerDisplayLogic: AnyObject
{
    func displayInitialView(viewModel: CategoryPicker.Refresh.ViewModel)
    func displayError(viewModel: CategoryPicker.Refresh.ViewModel)
}

class CategoryPickerViewController: DGSW_Petition_iOS.UIViewController, CategoryPickerDisplayLogic, UIGestureRecognizerDelegate {
    var interactor: CategoryPickerBusinessLogic?
    var router: (NSObjectProtocol & CategoryPickerRoutingLogic & CategoryPickerDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = CategoryPickerInteractor()
        let presenter = CategoryPickerPresenter()
        let router = CategoryPickerRouter()
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
    
    var dataSource: CategoryPickerViewDataSource?
    
    // MARK: - UI
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(CategoryPickerViewCategoryCell.self, forCellReuseIdentifier: CategoryPickerViewCategoryCell.registerId)
        $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.tableFooterView = UIView()
    }
    

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSettings(self, "카테고리 선택")
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        refresh()
    }
    
    //MARK: - receive events from UI
    
    
    
    // MARK: - request data from CategoryPickerInteractor

    func refresh() {
        let request = CategoryPicker.Refresh.Request()
        interactor?.refresh(request: request)
    }

    // MARK: - display view model from CategoryPickerPresenter

    func displayInitialView(viewModel: CategoryPicker.Refresh.ViewModel) {
        let categories = viewModel.categories?.map{ CategoryPickerViewCategoryCell.ViewModel(idx: $0.idx,
                                                                                             categoryName: $0.categoryName,
                                                                                             isSelected: $0.idx == router?.dataStore?.selectedCategoryIdx) } ?? []
        
        dataSource = CategoryPickerViewDataSource(categories: categories, delegate: self)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.reloadData()
    }
    
    func displayError(viewModel: CategoryPicker.Refresh.ViewModel) {
        toastMessage(viewModel.errorMessage, .error)
    }
    
}


extension CategoryPickerViewController: CategoryPickerViewDataSourceDelegate {
    func onClickCategoryCell(viewMdoel: CategoryPickerViewCategoryCell.ViewModel) {
        router?.routeToPetitionWriteView(selectedCategoryIdx: viewMdoel.idx, selectedCategoryName: viewMdoel.categoryName)
    }
}
