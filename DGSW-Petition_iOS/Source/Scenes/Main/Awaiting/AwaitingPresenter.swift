//
//  AwaitingPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol AwaitingPresentationLogic {
    func presentInitialView(response: Awaiting.Refresh.Response)
    func presentLoadMoreView(response: Awaiting.LoadMore.Response)
}

class AwaitingPresenter: AwaitingPresentationLogic {
    weak var viewController: AwaitingDisplayLogic?

    // MARK: Parse and calc respnse from AwaitingInteractor and send simple view model to AwaitingViewController to be displayed

    func presentInitialView(response: Awaiting.Refresh.Response) {
        
        let petitions = response.petitionSimpleInfos?.map {
            Awaiting.Refresh.ViewModel.Petition(idx: $0.idx,
                                               expirationDate: $0.expirationDate,
                                               category: $0.category,
                                               title: $0.title,
                                               agreeCount: $0.agreeCount)
        }
        
        let viewModel = Awaiting.Refresh.ViewModel(petitions: petitions,
                                                  errorMessage: response.error?.localizedDescription)
        
        viewController?.displayInitialView(viewModel: viewModel)
    }
    
    func presentLoadMoreView(response: Awaiting.LoadMore.Response) {
        let petitions = response.petitionSimpleInfos.map {
            Awaiting.LoadMore.ViewModel.Petition(idx: $0.idx,
                                               expirationDate: $0.expirationDate,
                                               category: $0.category,
                                               title: $0.title,
                                               agreeCount: $0.agreeCount)
        }
        
        let viewModel = Awaiting.LoadMore.ViewModel(petitions: petitions)
        
        viewController?.displayLoadMoreView(viewModel: viewModel)

    }
}
