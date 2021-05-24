//
//  OngoingPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol OngoingPresentationLogic {
    func presentInitialView(response: Ongoing.Refresh.Response)
    func presentLoadMoreView(response: Ongoing.LoadMore.Response)
}

class OngoingPresenter: OngoingPresentationLogic {
    weak var viewController: OngoingDisplayLogic?

    // MARK: Parse and calc respnse from OngoingInteractor and send simple view model to OngoingViewController to be displayed

    func presentInitialView(response: Ongoing.Refresh.Response) {
        
        let petitions = response.petitionSimpleInfos?.map {
            Ongoing.Refresh.ViewModel.Petition(idx: $0.idx,
                                               expirationDate: $0.expirationDate,
                                               category: $0.category,
                                               title: $0.title,
                                               agreeCount: $0.agreeCount)
        }
        
        let viewModel = Ongoing.Refresh.ViewModel(petitions: petitions,
                                                  errorMessage: response.error?.localizedDescription)
        
        viewController?.displayInitialView(viewModel: viewModel)
    }
    
    func presentLoadMoreView(response: Ongoing.LoadMore.Response) {
        let petitions = response.petitionSimpleInfos.map {
            Ongoing.LoadMore.ViewModel.Petition(idx: $0.idx,
                                               expirationDate: $0.expirationDate,
                                               category: $0.category,
                                               title: $0.title,
                                               agreeCount: $0.agreeCount)
        }
        
        let viewModel = Ongoing.LoadMore.ViewModel(petitions: petitions)
        
        viewController?.displayLoadMoreView(viewModel: viewModel)

    }
}
