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
    func displaySomething(viewModel: Completed.Something.ViewModel)
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
    
    // MARK: - UI
    
    

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        view.backgroundColor = .green
    }
    
    //MARK: - receive events from UI
    
    
    
    // MARK: - request data from CompletedInteractor

    func doSomething() {
        let request = Completed.Something.Request()
        interactor?.doSomething(request: request)
    }

    // MARK: - display view model from CompletedPresenter

    func displaySomething(viewModel: Completed.Something.ViewModel) {
        
    }
    
}
