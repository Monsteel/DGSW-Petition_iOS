//
//  AnswerWritePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/24.
//

import UIKit
import Moya

protocol AnswerWritePresentationLogic {
    func presentWriteAnswer(response: AnswerWrite.WriteAnswer.Response)
}

class AnswerWritePresenter: AnswerWritePresentationLogic {
    weak var viewController: AnswerWriteDisplayLogic?

    // MARK: Parse and calc respnse from AnswerWriteInteractor and send simple view model to AnswerWriteViewController to be displayed

    func presentWriteAnswer(response: AnswerWrite.WriteAnswer.Response) {
        guard let error = response.error else {
            viewController?.displayWriteAnswer(viewModel: .init(errorMessage: nil))
            return
        }
        
        viewController?.displayWriteAnswer(viewModel: .init(errorMessage: error.localizedDescription))
    }
    
}
