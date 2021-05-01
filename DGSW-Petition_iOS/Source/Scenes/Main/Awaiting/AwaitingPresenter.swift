//
//  AwaitingPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol AwaitingPresentationLogic {
    func presentSomething(response: Awaiting.Something.Response)
}

class AwaitingPresenter: AwaitingPresentationLogic {
    weak var viewController: AwaitingDisplayLogic?

    // MARK: Parse and calc respnse from AwaitingInteractor and send simple view model to AwaitingViewController to be displayed

    func presentSomething(response: Awaiting.Something.Response) {
        let viewModel = Awaiting.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
}
