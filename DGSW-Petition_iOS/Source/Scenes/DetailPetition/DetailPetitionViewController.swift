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
    
    func displayWriteAnswerResult(viewModel: DetailPetition.WriteAnswer.ViewModel)
    func displayWriteAnswerError(viewModel: DetailPetition.WriteAnswer.ViewModel)
}

class DetailPetitionViewController: DGSW_Petition_iOS.UIViewController, DetailPetitionDisplayLogic, UIGestureRecognizerDelegate {
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
    
    // MARK: - UI
    
    lazy var tableView = UITableView().then { _ in
        
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSettings(self, "청원 상세조회")
        
        refresh()
    }
    
    //MARK: - receive events from UI
    
    
    // MARK: - request data from DetailPetitionInteractor

    func refresh() {
        let request = DetailPetition.Refresh.Request()
        interactor?.refresh(request: request)
    }

    // MARK: - display view model from DetailPetitionPresenter (Success)

    func displayPetition(viewModel: DetailPetition.Refresh.ViewModel) {
        dump(viewModel)
    }
    
    func displayAgree(viewModel: DetailPetition.FetchAgree.ViewModel) {
        dump(viewModel)
    }
    
    func displayWriteAgreeResult(viewModel: DetailPetition.WriteAgree.ViewModel) {
        dump(viewModel)
    }
    
    func displayWriteAnswerResult(viewModel: DetailPetition.WriteAnswer.ViewModel) {
        dump(viewModel)
    }
    
    
    
    
    // MARK: - display view model from DetailPetitionPresenter (Error)
    
    func displayImportantError(viewModel: DetailPetition.Refresh.ViewModel) {
        dump(viewModel)
    }
    
    func displayAgreeError(viewModel: DetailPetition.FetchAgree.ViewModel) {
        dump(viewModel)
    }
    
    func displayWriteAgreeError(viewModel: DetailPetition.WriteAgree.ViewModel) {
        dump(viewModel)
    }
    
    func displayWriteAnswerError(viewModel: DetailPetition.WriteAnswer.ViewModel) {
        dump(viewModel)
    }
    
}
