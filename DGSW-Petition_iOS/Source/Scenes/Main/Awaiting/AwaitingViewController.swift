//
//  AwaitingViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit

protocol AwaitingDisplayLogic: class
{
    func displaySomething(viewModel: Awaiting.Something.ViewModel)
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
    
    // MARK: - UI
    
    

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        
        view.backgroundColor = .red
    }
    
    //MARK: - receive events from UI
    
    
    
    // MARK: - request data from AwaitingInteractor

    func doSomething() {
        let request = Awaiting.Something.Request()
        interactor?.doSomething(request: request)
    }

    // MARK: - display view model from AwaitingPresenter

    func displaySomething(viewModel: Awaiting.Something.ViewModel) {
        
    }
    
}
