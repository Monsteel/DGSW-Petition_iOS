//
//  RegisterPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/22.
//

import UIKit
import Moya

protocol RegisterPresentationLogic {
    func presentRegister(response: Register.Register.Response)
}

class RegisterPresenter: RegisterPresentationLogic {
    weak var viewController: RegisterDisplayLogic?

    // MARK: Parse and calc respnse from RegisterInteractor and send simple view model to RegisterViewController to be displayed

    func presentRegister(response: Register.Register.Response) {
        
        var errorMessage: String?
        
        if let error = response.error as? MoyaError {
            let errorBody = (try? error.response?.mapJSON() as? Dictionary<String, Any>) ?? Dictionary()
            errorMessage = errorBody["message"] as? String? ?? response.error?.localizedDescription
        }
        
        let viewModel = Register.Register.ViewModel.init(errorMessage: errorMessage)
        viewController?.displayRegister(viewModel: viewModel)
    }
}
