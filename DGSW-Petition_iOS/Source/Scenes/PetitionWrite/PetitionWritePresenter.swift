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
        
        guard let error = response.error else {
            let categoryName = response.categoryInfo?.categoryName ?? "= 카테고리 조회실패 ="
            
            let petition = response.petitionDetailInfo.map {
                PetitionWrite.Refresh.ViewModel.Petition(title: $0.title,
                                                         categoryName: categoryName,
                                                         content: $0.content,
                                                         fKeyword: $0.fkeyword,
                                                         sKeyword: $0.skeyword,
                                                         tKeyword: $0.tkeyword)
            }
            
            let viewModel = PetitionWrite.Refresh.ViewModel(petition: petition, errorMessage: nil)
            viewController?.displayPetitionInfo(viewModel: viewModel)
            
            return
        }
        
        switch error {
            case .NotSelectedCategory:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .NotEnteredTitle:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .NotEnteredContent:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .FailModifyPetition:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .FailWritePetition:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .FailFetchPetition:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .UnAuthorized:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .InternalServerError:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .UnhandledError:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .NetworkError:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
            case .TokenExpiration:
                viewController?.displayErrorMessage(viewModel: .init(petition: nil, errorMessage: error.localizedDescription))
        }
    }
    
    func presentWriteResult(response: PetitionWrite.WritePetition.Response) {
        guard let error = response.error else {
            viewController?.displayWriteResult(viewModel: .init(errorMessage: nil))
            return
        }
        
        switch error {
            case .NotSelectedCategory:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .NotEnteredTitle:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .NotEnteredContent:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .FailModifyPetition:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .FailWritePetition:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .FailFetchPetition:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .UnAuthorized:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .InternalServerError:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .UnhandledError:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .NetworkError:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
            case .TokenExpiration:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.WritePetition.ViewModel(errorMessage: error.localizedDescription))
        }
    }
    
    func presentModifyResult(response: PetitionWrite.ModifyPetition.Response) {
        guard let error = response.error else {
            viewController?.displayModifyResult(viewModel: .init(errorMessage: nil))
            return
        }
        
        switch error {
            case .NotSelectedCategory:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .NotEnteredTitle:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .NotEnteredContent:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .FailModifyPetition:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .FailWritePetition:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .FailFetchPetition:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .UnAuthorized:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .InternalServerError:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .UnhandledError:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .NetworkError:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
            case .TokenExpiration:
                viewController?.displayErrorMessage(viewModel: PetitionWrite.ModifyPetition.ViewModel(errorMessage: error.localizedDescription))
        }
    }
    
}
