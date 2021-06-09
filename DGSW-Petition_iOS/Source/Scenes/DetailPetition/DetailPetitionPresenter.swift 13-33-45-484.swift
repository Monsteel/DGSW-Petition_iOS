//
//  DetailPetitionPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit

protocol DetailPetitionPresentationLogic {
    func presentSomething(response: DetailPetition.Something.Response)
}

class DetailPetitionPresenter: DetailPetitionPresentationLogic {
    weak var viewController: DetailPetitionDisplayLogic?

    // MARK: Parse and calc respnse from DetailPetitionInteractor and send simple view model to DetailPetitionViewController to be displayed

    func presentSomething(response: DetailPetition.Something.Response) {
        let viewModel = DetailPetition.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
}
