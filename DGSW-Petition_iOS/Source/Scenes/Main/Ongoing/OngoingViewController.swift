//
//  OngoingViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit
import SnapKit

protocol OngoingDisplayLogic: class
{
    func displaySomething(viewModel: Ongoing.Something.ViewModel)
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
    
    // MARK: - UI
    
    

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        view.backgroundColor = .yellow
    }
    
    //MARK: - receive events from UI
    
    
    
    // MARK: - request data from OngoingInteractor

    func doSomething() {
        let request = Ongoing.Something.Request()
        interactor?.doSomething(request: request)
    }

    // MARK: - display view model from OngoingPresenter

    func displaySomething(viewModel: Ongoing.Something.ViewModel) {
        
    }
    
}
