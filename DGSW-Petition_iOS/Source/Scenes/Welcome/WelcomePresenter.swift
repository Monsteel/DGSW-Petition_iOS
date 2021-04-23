//
//  WelcomePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import UIKit

protocol WelcomePresentationLogic {
    func presentLogin(response: Welcome.Login.Response)
    func presentCheckRegisteredUser(response: Welcome.CheckRegisteredUser.Response)
}

class WelcomePresenter: WelcomePresentationLogic {
    weak var viewController: WelcomeDisplayLogic?

    // MARK: Parse and calc respnse from WelcomeInteractor and send simple view model to WelcomeViewController to be displayed

    func presentLogin(response: Welcome.Login.Response) {
        let viewModel = Welcome.Login.ViewModel(errorMessage: response.error?.localizedDescription)
        viewController?.displayLogin(viewModel: viewModel)
    }
    
    func presentCheckRegisteredUser(response: Welcome.CheckRegisteredUser.Response) {
        let viewModel = Welcome.CheckRegisteredUser.ViewModel(isRegistered: response.isRegistered,
                                                              errorMessage: response.error?.localizedDescription)
        viewController?.displayCheckRegisteredUser(viewModel: viewModel)
    }
}
