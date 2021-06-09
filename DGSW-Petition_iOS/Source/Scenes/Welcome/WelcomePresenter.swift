//
//  WelcomePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import UIKit
import Moya

protocol WelcomePresentationLogic {
    func presentLogin(response: Welcome.Login.Response)
    func presentCheckRegisteredUser(response: Welcome.CheckRegisteredUser.Response)
}

class WelcomePresenter: WelcomePresentationLogic {
    weak var viewController: WelcomeDisplayLogic?

    // MARK: Parse and calc respnse from WelcomeInteractor and send simple view model to WelcomeViewController to be displayed

    func presentLogin(response: Welcome.Login.Response) {
        guard let error = response.error else { return displayLogin() }
        switch error {
            case .FailCheckRegisteredUser:
                displayLoginErrorMessage(error.localizedDescription)
            case .FailLogin:
                displayLoginErrorMessage(error.localizedDescription)
            case .InternalServerError:
                displayLoginErrorMessage(error.localizedDescription)
            case .UnhandledError:
                displayLoginErrorMessage(error.localizedDescription)
            case .NetworkError:
                displayLoginErrorMessage(error.localizedDescription)
        }
    }
    
    func presentCheckRegisteredUser(response: Welcome.CheckRegisteredUser.Response) {
        guard let error = response.error else { return displayCheckRegisteredUser(response.isRegistered) }
        switch error {
            case .FailCheckRegisteredUser:
                displayRetryCheckRegisteredUserAlert(error.localizedDescription)
            case .FailLogin:
                displayRetryCheckRegisteredUserAlert(error.localizedDescription)
            case .InternalServerError:
                displayRetryCheckRegisteredUserAlert(error.localizedDescription)
            case .UnhandledError:
                displayRetryCheckRegisteredUserAlert(error.localizedDescription)
            case .NetworkError:
                displayRetryCheckRegisteredUserAlert(error.localizedDescription)
        }
    }
}

extension WelcomePresenter {
    func displayCheckRegisteredUser(_ isRegistered: Bool){
        let viewModel = Welcome.CheckRegisteredUser.ViewModel(isRegistered: true)
        viewController?.displayCheckRegisteredUser(viewModel: viewModel)
    }
    
    func displayLogin(){
        let viewModel = Welcome.Login.ViewModel()
        viewController?.displayLogin(viewModel: viewModel)
    }
    
    func displayRetryCheckRegisteredUserAlert(_ errorMessage: String){
        let viewModel = Welcome.CheckRegisteredUser.ViewModel(isRegistered: false, errorMessage: errorMessage)
        viewController?.displayRetryCheckRegisteredUserAlert(viewModel: viewModel)
    }
    
    func displayLoginErrorMessage(_ errorMessage: String){
        let viewModel = Welcome.Login.ViewModel(errorMessage: errorMessage)
        viewController?.displayLoginErrorMessage(viewModel: viewModel)
    }
}
