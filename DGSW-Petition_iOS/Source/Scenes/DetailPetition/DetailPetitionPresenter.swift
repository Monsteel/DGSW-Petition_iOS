//
//  DetailPetitionPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit

protocol DetailPetitionPresentationLogic {
    func presentInitialView(response: DetailPetition.Refresh.Response)
    func presentAgree(response: DetailPetition.FetchAgree.Response)
    func presentWriteAgreeResult(response: DetailPetition.WriteAgree.Response)
    func presentWriteAnswerResult(response: DetailPetition.WriteAnswer.Response)
}

class DetailPetitionPresenter: DetailPetitionPresentationLogic {
    weak var viewController: DetailPetitionDisplayLogic?

    // MARK: Parse and calc respnse from DetailPetitionInteractor and send simple view model to DetailPetitionViewController to be displayed

    func presentInitialView(response: DetailPetition.Refresh.Response) {
        guard let error = response.error else {
            displayPetition(writerID: response.petitionDetailInfo!.writerID,
                            createdAt: response.petitionDetailInfo!.createdAt,
                            expirationDate: response.petitionDetailInfo!.expirationDate,
                            category: response.categoryInfo?.categoryName ?? "= 카테고리 조회 실패 =",
                            title: response.petitionDetailInfo!.title,
                            content: response.petitionDetailInfo!.content,
                            agreeCount: response.petitionDetailInfo!.agreeCount,
                            answerContent: response.answerInfos?.map{ $0.content })
            return
        }
        displayImportantError(error)
    }
    
    func presentAgree(response: DetailPetition.FetchAgree.Response) {
        if let error = response.error {
            viewController?.displayAgreeError(viewModel: .init(answers: nil, errorMessage: error.localizedDescription))
        }else{
            viewController?.displayAgree(viewModel: .init(answers: response.agreeDetailInfos?.map{ .init(writerID: $0.userID, content: $0.content)}, errorMessage: nil))
        }
    }
    
    func presentWriteAgreeResult(response: DetailPetition.WriteAgree.Response) {
        if let error = response.error {
            viewController?.displayWriteAgreeError(viewModel: .init(errorMessage: error.localizedDescription))
        }else{
            viewController?.displayWriteAgreeResult(viewModel: .init(errorMessage: nil))
        }
    }
    
    func presentWriteAnswerResult(response: DetailPetition.WriteAnswer.Response) {
        if let error = response.error {
            viewController?.displayWriteAnswerError(viewModel: .init(errorMessage: error.localizedDescription))
        }else{
            viewController?.displayWriteAnswerResult(viewModel: .init(errorMessage: nil))
        }
    }
}

extension DetailPetitionPresenter {
    func displayPetition(writerID: String, createdAt: Date, expirationDate: Date,
                         category: String, title: String, content: String,
                         agreeCount: Int, answerContent: [String]?){
        viewController?.displayPetition(viewModel:
                                            .init(petiton:
                                                    .init(writerID: writerID, createdAt: createdAt, expirationDate: expirationDate,
                                                          category: category, title: title, content: content,
                                                          agreeCount: agreeCount, answerContent: answerContent),
                                                  errorMessage: nil)
        )
    }
    
    func displayImportantError(_ err: DetailPetitionError?){
        viewController?.displayImportantError(viewModel: .init(petiton: nil, errorMessage: err?.localizedDescription))
    }
}
