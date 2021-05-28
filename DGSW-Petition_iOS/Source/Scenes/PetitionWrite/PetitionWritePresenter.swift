//
//  PetitionWritePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

protocol PetitionWritePresentationLogic {
    func presentRefreshResult(response: PetitionWrite.Refresh.Response)
    func presentWriteResult(response: PetitionWrite.WritePetition.Response)
    func presentModifyResult(response: PetitionWrite.ModifyPetition.Response)
}

class PetitionWritePresenter: PetitionWritePresentationLogic {
    weak var viewController: PetitionWriteDisplayLogic?

    // MARK: Parse and calc respnse from PetitionWriteInteractor and send simple view model to PetitionWriteViewController to be displayed

    func presentRefreshResult(response: PetitionWrite.Refresh.Response) {
        let categoryName = response.categoryInfo?.categoryName ?? ""
        
        let petition = response.petitionDetailInfo.map {
            PetitionWrite.Refresh.ViewModel.Petition(title: $0.title,
                                                     categoryName: categoryName,
                                                     content: $0.content,
                                                     fKeyword: $0.fKeyword,
                                                     sKeyword: $0.sKeyword,
                                                     tKeyword: $0.tKeyword)
        }
        
        let viewModel = PetitionWrite.Refresh.ViewModel(petition: petition, errorMessage: response.error?.localizedDescription)
        viewController?.displayPetitionInfo(viewModel: viewModel)
    }
    
    func presentWriteResult(response: PetitionWrite.WritePetition.Response) {
        let viewModel = PetitionWrite.WritePetition.ViewModel(errorMessage: response.error?.localizedDescription)
        viewController?.displayWriteResult(viewModel: viewModel)
    }
    
    func presentModifyResult(response: PetitionWrite.ModifyPetition.Response) {
        let viewModel = PetitionWrite.ModifyPetition.ViewModel(errorMessage: response.error?.localizedDescription)
        viewController?.displayModifyResult(viewModel: viewModel)
    }
    
}
