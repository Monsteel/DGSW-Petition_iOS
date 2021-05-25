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
        var errorMessage: String?
        
        if let error = response.error as? MoyaError {
            let errorBody = (try? error.response?.mapJSON() as? Dictionary<String, Any>) ?? Dictionary()
            errorMessage = errorBody["message"] as? String? ?? response.error?.localizedDescription
        }
        
        let viewModel = AnswerWrite.WriteAnswer.ViewModel(errorMessage: errorMessage)
        viewController?.displayWriteAnswer(viewModel: viewModel)
    }
    
}
