//
//  HomePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol HomePresentationLogic {
    func presentTopTenPetition(response: Home.Refresh.Response)
    func presentPetitionSituation(response: Home.Refresh.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    // MARK: Parse and calc respnse from HomeInteractor and send simple view model to HomeViewController to be displayed
    
    func presentTopTenPetition(response: Home.Refresh.Response) {
        displayTopTenPetition(response.petitionSimpleInfosError, response.petitionSimpleInfos, response.categoryInfos)
    }
    
    func presentPetitionSituation(response: Home.Refresh.Response) {
        displayPetitionSituation(response.petitionSituationInfoError, response.petitionSituationInfo)
    }
}


extension HomePresenter {
    func displayPetitionSituation(_ error: HomeError?, _ petitionSituationInfo: PetitionSituationInfo?) {
        guard let error =  error else {
            let petitionSituation = petitionSituationInfo.map {
                Home.Refresh.ViewModel.PetitionSituation(agreeCount: $0.agreeCount,
                                                         completedCount: $0.answerCount,
                                                         awaitingCount: $0.awaitingPetitionCount)
            }
            let viewModel = Home.Refresh.ViewModel(topTenPetitions: nil,
                                                   petitionSituation: petitionSituation,
                                                   errorMessage: nil)
            
            viewController?.displayPetitionSituation(viewModel: viewModel)
            
            return
        }
        
        
        let containedErrorMessageViewModel = Home.Refresh.ViewModel(topTenPetitions: nil,
                                                                    petitionSituation: nil,
                                                                    errorMessage: error.localizedDescription)
        
        switch error {
            case .FailPetitionSituation:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .FailTopTenPetition:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .UnAuthorized:
                viewController?.displayWelcomeView(viewModel: containedErrorMessageViewModel)
            case .InternalServerError:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .UnhandledError:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .NetworkError:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .TokenExpiration:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
        }
    }
    
    func displayTopTenPetition(_ error: HomeError?, _ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?) {
        guard let error =  error else {
            let petitionSimpleInfos = petitionSimpleInfos?.map { simpleInfo -> Home.Refresh.ViewModel.Petition in
                
                let currentCategory = categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "= 카테고리 조회실패 ="
                
                return Home.Refresh.ViewModel.Petition(idx: simpleInfo.idx,
                                                       expirationDate: simpleInfo.expirationDate,
                                                       category: currentCategory,
                                                       title: simpleInfo.title,
                                                       agreeCount: simpleInfo.agreeCount)
            }
            
            let viewModel = Home.Refresh.ViewModel(topTenPetitions: petitionSimpleInfos,
                                                   petitionSituation: nil,
                                                   errorMessage: nil)
            
            viewController?.displayTopTenPetition(viewModel: viewModel)
            
            return
        }
        
        
        let containedErrorMessageViewModel = Home.Refresh.ViewModel(topTenPetitions: nil,
                                                                    petitionSituation: nil,
                                                                    errorMessage: error.localizedDescription)
        
        switch error {
            case .FailPetitionSituation:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .FailTopTenPetition:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .UnAuthorized:
                viewController?.displayWelcomeView(viewModel: containedErrorMessageViewModel)
            case .InternalServerError:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .UnhandledError:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .NetworkError:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
            case .TokenExpiration:
                viewController?.displayPetitionSituationError(viewModel: containedErrorMessageViewModel)
        }
    }
}
