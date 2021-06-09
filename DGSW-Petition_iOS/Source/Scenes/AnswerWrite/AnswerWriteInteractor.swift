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
        
        if(targetPetitionIdx == nil){
            presenter?.presentWriteAnswer(response: .init(error: .UnhandledError(msg: "답변 대상을 찾을 수 없음")))
        }
        
        if(request.content.isEmpty){
            presenter?.presentWriteAnswer(response: .init(error: .NotEnteredContent))
            return
        }
        
        let request = AnswerRequest(petitionIdx: request.petitionIdx,
                                    content: request.content)
        
        worker?.addAnswer(request) { [weak self] in
            var response = AnswerWrite.WriteAnswer.Response()
            if case let .failure(err) = $0 { response.error = err.toAnswerWriteError(.FailWritePetition) }
            self?.presenter?.presentWriteAnswer(response: response)
        }
    }
    
}
