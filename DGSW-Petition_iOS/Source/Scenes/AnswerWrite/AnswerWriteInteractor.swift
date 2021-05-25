//
//  AnswerWriteInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/24.
//

import UIKit

protocol AnswerWriteBusinessLogic {
    func writeAnswer(request: AnswerWrite.WriteAnswer.Request)
}

protocol AnswerWriteDataStore {
    var targetPetitionIdx: Int? { get set }
}

class AnswerWriteInteractor: AnswerWriteBusinessLogic, AnswerWriteDataStore {
    var presenter: AnswerWritePresentationLogic?
    var worker: AnswerWorker?
    
    var targetPetitionIdx: Int?

    // MARK: Do something (and send response to AnswerWritePresenter)

    func writeAnswer(request: AnswerWrite.WriteAnswer.Request) {
        worker = AnswerWorker.shared
        
        let request = AnswerRequest(petitionIdx: request.petitionIdx,
                                    content: request.content)
        
        worker?.addAnswer(request) { [weak self] in
            var response = AnswerWrite.WriteAnswer.Response()
            if case let .failure(err) = $0 { response.error = err }
            self?.presenter?.presentWriteAnswer(response: response)
        }
    }
    
}
