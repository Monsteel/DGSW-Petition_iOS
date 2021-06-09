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
        guard let error = response.error else { return displayRegister() }
        
        switch error {
            case .FailRegister:
                displayRegisterErrorMessage(error.localizedDescription)
            case .UnAuthorized:
                displayRegisterErrorMessage(error.localizedDescription)
            case .InternalServerError:
                displayRegisterErrorMessage(error.localizedDescription)
            case .UnhandledError:
                displayRegisterErrorMessage(error.localizedDescription)
            case .NetworkError:
                displayRegisterErrorMessage(error.localizedDescription)
            case .TokenExpiration:
                displayRegisterErrorMessage(error.localizedDescription)
        }
    }
}

extension RegisterPresenter {
    func displayRegister(){
        let viewModel = Register.Register.ViewModel()
        viewController?.displayRegister(viewModel: viewModel)
    }
    
    func displayRegisterErrorMessage(_ errorMessage: String){
        let viewModel = Register.Register.ViewModel(errorMessage: errorMessage)
        viewController?.displayRegister(viewModel: viewModel)
    }
}
