//
//  SplashViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import UIKit
import SnapKit

protocol SplashDisplayLogic: AnyObject
{
    func displayWelcomeView(viewModel: Splash.Refresh.ViewModel)
    func displayMainView(viewModel: Splash.Refresh.ViewModel)
    func displayRetryAlert(viewModel: Splash.Refresh.ViewModel)
}

class SplashViewController: DGSW_Petition_iOS.UIViewController, SplashDisplayLogic {
    var interactor: SplashBusinessLogic?
    var router: (NSObjectProtocol & SplashRoutingLogic & SplashDataPassing)?
    
    // MARK: Setup Clean Code Design Pattern

    internal override func setup() {
        let viewController = self
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    //MARK: - receive events from UI
    
    // MARK: - request data from SplashInteractor

    func refresh() {
        let request = Splash.Refresh.Request()
        interactor?.refresh(request: request)
    }

    // MARK: - display view model from SplashPresenter
    
    func displayWelcomeView(viewModel: Splash.Refresh.ViewModel) {
        router?.routeToWelcomeView()
    }
    
    func displayMainView(viewModel: Splash.Refresh.ViewModel) {
        router?.routeToMainView()
    }
    
    func displayRetryAlert(viewModel: Splash.Refresh.ViewModel) {
        retryAlertshow(message: viewModel.errorMessage){ [weak self] _ in
            self?.refresh()
        }
    }
}

extension SplashViewController {
    func retryAlertshow(title: String? = "오류가 발생했습니다.", message: String? = "알 수 없음", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: "사유: \(message ?? "알 수 없음")", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "초기화면으로 이동", style: .cancel, handler: { [weak self] _ in
            KeychainManager.shared.logout()
            self?.router?.routeToWelcomeView()
        }))
        alert.addAction(UIAlertAction(title: "재시도", style: .default, handler:  handler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
