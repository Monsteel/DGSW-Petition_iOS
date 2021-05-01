//
//  CompletedPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol CompletedPresentationLogic {
    func presentSomething(response: Completed.Something.Response)
}

class CompletedPresenter: CompletedPresentationLogic {
    weak var viewController: CompletedDisplayLogic?

    // MARK: Parse and calc respnse from CompletedInteractor and send simple view model to CompletedViewController to be displayed

    func presentSomething(response: Completed.Something.Response) {
        let viewModel = Completed.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
}
