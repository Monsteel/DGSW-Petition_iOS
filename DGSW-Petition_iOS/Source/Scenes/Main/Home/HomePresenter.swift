//
//  HomePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol HomePresentationLogic {
    func presentSomething(response: Home.Something.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    // MARK: Parse and calc respnse from HomeInteractor and send simple view model to HomeViewController to be displayed

    func presentSomething(response: Home.Something.Response) {
        let viewModel = Home.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
}
