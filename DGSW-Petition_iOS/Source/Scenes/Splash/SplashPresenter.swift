//
//  SplashPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import UIKit

protocol SplashPresentationLogic {
    func presentRefrestResult(response: Splash.Refresh.Response)
}

class SplashPresenter: SplashPresentationLogic {
    weak var viewController: SplashDisplayLogic?

    // MARK: Parse and calc respnse from SplashInteractor and send simple view model to SplashViewController to be displayed

    func presentRefrestResult(response: Splash.Refresh.Response) {
        guard let error = response.error else { return displayMainView() }
        
        switch error {
            case .UnAuthorized:
                displayWelcomeView()
            case .FailFetchMyInfo:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .FailCategoryInfo:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .FailSaveMyInfo:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .FailSaveCategoryInfo:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .InternalServerError:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .UnhandledError:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .NetworkError:
                displayRetryAlert(errorMessage: error.localizedDescription)
            case .TokenExpiration:
                displayRetryAlert(errorMessage: error.localizedDescription)
        }
    }
}

extension SplashPresenter {
    func displayRetryAlert(errorMessage: String) {
        let viewModel = Splash.Refresh.ViewModel(errorMessage: errorMessage)
        viewController?.displayRetryAlert(viewModel: viewModel)
    }
    
    func displayMainView() {
        let viewModel = Splash.Refresh.ViewModel(errorMessage: nil)
        viewController?.displayMainView(viewModel: viewModel)
    }
    
    func displayWelcomeView() {
        let viewModel = Splash.Refresh.ViewModel(errorMessage: nil)
        viewController?.displayWelcomeView(viewModel: viewModel)
    }
}
