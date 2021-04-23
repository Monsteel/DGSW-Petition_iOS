//
//  RegisterPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/22.
//

import UIKit

protocol RegisterPresentationLogic {
    func presentRegister(response: Register.Register.Response)
}

class RegisterPresenter: RegisterPresentationLogic {
    weak var viewController: RegisterDisplayLogic?

    // MARK: Parse and calc respnse from RegisterInteractor and send simple view model to RegisterViewController to be displayed

    func presentRegister(response: Register.Register.Response) {
        let viewModel = Register.Register.ViewModel.init(errorMessage: response.error?.localizedDescription)
        viewController?.displayRegister(viewModel: viewModel)
    }
}
