//
//  DetailPetitionViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit
import SnapKit

protocol DetailPetitionDisplayLogic: AnyObject
{
    func displayPetition(viewModel: DetailPetition.Refresh.ViewModel)
    func displayImportantError(viewModel: DetailPetition.Refresh.ViewModel)
    
    func displayAgree(viewModel: DetailPetition.FetchAgree.ViewModel)
    func displayAgreeError(viewModel: DetailPetition.FetchAgree.ViewModel)
    
    func displayWriteAgreeResult(viewModel: DetailPetition.WriteAgree.ViewModel)
    func displayWriteAgreeError(viewModel: DetailPetition.WriteAgree.ViewModel)
    
    func displayDeletePetitionResult(viewModel: DetailPetition.DeletePetition.ViewModel)
    func displayDeletePetitionError(viewModel: DetailPetition.DeletePetition.ViewModel)
}

class DetailPetitionViewController: DGSW_Petition_iOS.UIViewController, DetailPetitionDisplayLogic, UIGestureRecognizerDelegate, DetailPetitionViewDataSourceDelegate, DetailPetitionViewAgreeWriteCellDelegate, UITableViewDelegate {
    var interactor: DetailPetitionBusinessLogic?
    var router: (NSObjectProtocol & DetailPetitionRoutingLogic & DetailPetitionDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = DetailPetitionInteractor()
        let presenter = DetailPetitionPresenter()
        let router = DetailPetitionRouter()
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

    // MARK: - Properties
    var dataSource: DetailPetitionViewDataSource?
    
    // MARK: - UI
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(DetailPetitionViewStatusCell.self, forCellReuseIdentifier: DetailPetitionViewStatusCell.registerId)
        $0.register(DetailPetitionViewTitleCell.self, forCellReuseIdentifier: DetailPetitionViewTitleCell.registerId)
        $0.register(DetailPetitionViewAgreeCountCell.self, forCellReuseIdentifier: DetailPetitionViewAgreeCountCell.registerId)
        $0.register(DetailPetitionInfoCell.self, forCellReuseIdentifier: DetailPetitionInfoCell.registerId)
        $0.register(DetailPetitionViewProgressCell.self, forCellReuseIdentifier: DetailPetitionViewProgressCell.registerId)
        $0.register(DetailPetitionViewAnswerCell.self, forCellReuseIdentifier: DetailPetitionViewAnswerCell.registerId)
        $0.register(DetailPetitionViewContentCell.self, forCellReuseIdentifier: DetailPetitionViewContentCell.registerId)
        $0.register(DetailPetitionViewAgreeInfoCell.self, forCellReuseIdentifier: DetailPetitionViewAgreeInfoCell.registerId)
        $0.register(DetailPetitionViewAgreeWriteCell.self, forCellReuseIdentifier: DetailPetitionViewAgreeWriteCell.registerId)
        $0.register(DetailPetitionViewAgreeFooter.self, forHeaderFooterViewReuseIdentifier: DetailPetitionViewAgreeFooter.registerId)
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 130
        $0.rowHeight = UITableView.automaticDimension
        $0.allowsSelection = false
        $0.isUserInteractionEnabled = true
        $0.keyboardDismissMode = .interactive
    }
    
    var alertController: UIAlertController!
    
    private func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.refreshControl = refreshControl
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSettings(self, "청원 상세조회")
        
        addKeyboardNotification()
        addRefreshControl()
        
        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    //MARK: - receive events from UI
    
    func onClickloadAgreeBtn() {
        if let page = dataSource?.agreePageCount {
            interactor?.fetchAgree(request: .init(page: page))
        } else {
            toastMessage("잘못된 접근", .error)
        }
    }
    
    func onClickAgreeBtn(_ content: String) {
        interactor?.writeAgree(request: .init(content: content))
    }
    
    // MARK: - request data from DetailPetitionInteractor

    @objc
    func refresh() {
        let request = DetailPetition.Refresh.Request()
        interactor?.refresh(request: request)
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc
    func delete(idx: Int) {
        let request = DetailPetition.DeletePetition.Request(idx: idx)
        interactor?.deletePetition(request: request)
    }

    // MARK: - display view model from DetailPetitionPresenter (Success)

    func displayPetition(viewModel: DetailPetition.Refresh.ViewModel) {
        let editButton   = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapEditButton))
        editButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = editButton
        
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(viewModel.petiton?.writerID == viewModel.myInfo?.userID &&
            viewModel.petiton!.agreeCount < Constants.DO_NOT_MODIFY_AGREE_COUNT &&
            !viewModel.petiton!.isAnswer){
            alertController.addAction(.init(title: "수정", style: .default) { _ in
                self.router?.routeToWritePetitionView(viewModel.petiton!.idx)
            })
            alertController.addAction(.init(title: "삭제", style: .default) { _ in
                self.delete(idx: viewModel.petiton!.idx)
            })
        }
        
        if(viewModel.myInfo!.permissionType == .EXECUTIVE){
            alertController.addAction(.init(title: "답변추가", style: .default) { _ in
                self.router?.routeToWriteAnswerView(viewModel.petiton!.idx)
            })
        }
        
        alertController.addAction(.init(title: "취소", style: .cancel) { _ in })
        
        dataSource = DetailPetitionViewDataSource(viewModel, self)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
    
    @objc
    func didTapEditButton() {
        self.present(self.alertController, animated: true, completion: nil)
    }
    
    func displayAgree(viewModel: DetailPetition.FetchAgree.ViewModel) {
        dataSource?.loadAgree(viewModel)
        tableView.reloadData()
    }
    
    func displayWriteAgreeResult(viewModel: DetailPetition.WriteAgree.ViewModel) {
        toastMessage("동의 완료!", .success)
        refresh()
    }
    func displayDeletePetitionResult(viewModel: DetailPetition.DeletePetition.ViewModel) {
        toastMessage("삭제 완료!", .success)
        router?.routeToPreviousView()
    }
    
    // MARK: - display view model from DetailPetitionPresenter (Error)
    
    func displayImportantError(viewModel: DetailPetition.Refresh.ViewModel) {
        toastMessage(viewModel.errorMessage, .error)
    }
    
    func displayAgreeError(viewModel: DetailPetition.FetchAgree.ViewModel) {
        toastMessage(viewModel.errorMessage, .error)
    }
    
    func displayWriteAgreeError(viewModel: DetailPetition.WriteAgree.ViewModel) {
        toastMessage(viewModel.errorMessage, .error)
    }
    
    func displayDeletePetitionError(viewModel: DetailPetition.DeletePetition.ViewModel) {
        toastMessage(viewModel.errorMessage, .error)
    }
}

extension DetailPetitionViewController {
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
        
        self.tableView.contentInset.bottom = keyboardFrame.size.height
        scrollTo(section: 1, row: 0)
    }
    
    @objc private func keyboardWillHide(_ noti: Notification){
        let contentInset = UIEdgeInsets.zero
        
        self.tableView.contentInset = contentInset
        self.tableView.scrollIndicatorInsets = contentInset
    }
    
    func scrollTo(section: Int, row: Int){
        let indexPath = IndexPath(row: row, section: section)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
