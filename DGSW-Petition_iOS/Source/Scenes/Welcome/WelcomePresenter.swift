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
        var errorMessage: String?
        
        if let error = response.error as? MoyaError {
            let errorBody = (try? error.response?.mapJSON() as? Dictionary<String, Any>) ?? Dictionary()
            errorMessage = errorBody["message"] as? String? ?? response.error?.localizedDescription
        }
        
        let viewModel = Welcome.Login.ViewModel(errorMessage: errorMessage)
        viewController?.displayLogin(viewModel: viewModel)
    }
    
    func presentCheckRegisteredUser(response: Welcome.CheckRegisteredUser.Response) {
        
        var errorMessage: String?
        
        if let error = response.error as? MoyaError {
            let errorBody = (try? error.response?.mapJSON() as? Dictionary<String, Any>) ?? Dictionary()
            errorMessage = errorBody["message"] as? String? ?? response.error?.localizedDescription
        }
        
        let viewModel = Welcome.CheckRegisteredUser.ViewModel(isRegistered: response.isRegistered,
                                                              errorMessage: errorMessage)
        viewController?.displayCheckRegisteredUser(viewModel: viewModel)
    }
}
