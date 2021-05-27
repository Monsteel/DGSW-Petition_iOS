//
//  HomePresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol HomePresentationLogic {
    func presentInitialView(response: Home.Refresh.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    // MARK: Parse and calc respnse from HomeInteractor and send simple view model to HomeViewController to be displayed

    func presentInitialView(response: Home.Refresh.Response) {
        
        let topTenPetitions = response.petitionSimpleInfos?.map { simpleInfo in
            return Home.Refresh.ViewModel.Petition(idx: simpleInfo.idx,
                                                   expirationDate: simpleInfo.expirationDate,
                                                   category: response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "=카테고리 조회실패=",
                                                   title: simpleInfo.title,
                                                   agreeCount: simpleInfo.agreeCount)
        }
        
        var topTenPetitionErrorMessage: String? = nil
        
        
        let petitionSituation = response.petitionSituationInfo.map {
            Home.Refresh.ViewModel.PetitionSituation(agreeCount: $0.agreeCount, completedCount: $0.answerCount, awaitingCount: $0.awaitingPetitionCount)
        }
        
        var petitionSituationErrorMessage: String? = nil
        
        
        switch (response.error as? HomeError) {
            case .getPetitionSituationError(let message): topTenPetitionErrorMessage = message
            case .getTopTenPetitionError(let message): petitionSituationErrorMessage = message
            case .none: break
        }
        
        
        viewController?.displayInitialView(viewModel: Home.Refresh.ViewModel(topTenPetitions: topTenPetitions,
                                                                             topTenPetitionErrorMessage: topTenPetitionErrorMessage,
                                                                             petitionSituation: petitionSituation,
                                                                             petitionSituationErrorMessage: petitionSituationErrorMessage))
        
    }
}
