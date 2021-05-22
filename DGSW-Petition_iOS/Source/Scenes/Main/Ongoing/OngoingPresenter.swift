//
//  OngoingPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol OngoingPresentationLogic {
    func presentSomething(response: Ongoing.Something.Response)
}

class OngoingPresenter: OngoingPresentationLogic {
    weak var viewController: OngoingDisplayLogic?

    // MARK: Parse and calc respnse from OngoingInteractor and send simple view model to OngoingViewController to be displayed

    func presentSomething(response: Ongoing.Something.Response) {
        let viewModel = Ongoing.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
}
