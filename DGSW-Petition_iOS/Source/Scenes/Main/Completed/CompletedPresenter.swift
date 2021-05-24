//
//  CompletedPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol CompletedPresentationLogic {
    func presentInitialView(response: Completed.Refresh.Response)
    func presentLoadMoreView(response: Completed.LoadMore.Response)
}

class CompletedPresenter: CompletedPresentationLogic {
    weak var viewController: CompletedDisplayLogic?

    // MARK: Parse and calc respnse from CompletedInteractor and send simple view model to CompletedViewController to be displayed

    func presentInitialView(response: Completed.Refresh.Response) {
        
        let petitions = response.petitionSimpleInfos?.map {
            Completed.Refresh.ViewModel.Petition(idx: $0.idx,
                                               expirationDate: $0.expirationDate,
                                               category: $0.category,
                                               title: $0.title,
                                               agreeCount: $0.agreeCount)
        }
        
        let viewModel = Completed.Refresh.ViewModel(petitions: petitions,
                                                  errorMessage: response.error?.localizedDescription)
        
        viewController?.displayInitialView(viewModel: viewModel)
    }
    
    func presentLoadMoreView(response: Completed.LoadMore.Response) {
        let petitions = response.petitionSimpleInfos.map {
            Completed.LoadMore.ViewModel.Petition(idx: $0.idx,
                                               expirationDate: $0.expirationDate,
                                               category: $0.category,
                                               title: $0.title,
                                               agreeCount: $0.agreeCount)
        }
        
        let viewModel = Completed.LoadMore.ViewModel(petitions: petitions)
        
        viewController?.displayLoadMoreView(viewModel: viewModel)

    }
}
