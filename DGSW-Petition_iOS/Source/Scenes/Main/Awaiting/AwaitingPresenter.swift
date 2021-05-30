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
        
        let petitions = response.petitionSimpleInfos?.map { simpleInfo -> Awaiting.Refresh.ViewModel.Petition in
            let currentCategory = response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "= 카테고리 조회실패 ="
            
            return Awaiting.Refresh.ViewModel.Petition(idx: simpleInfo.idx,
                                                       expirationDate: simpleInfo.expirationDate,
                                                       category: currentCategory,
                                                       title: simpleInfo.title,
                                                       agreeCount: simpleInfo.agreeCount)
        }
        
        let viewModel = Awaiting.Refresh.ViewModel(petitions: petitions,
                                                  errorMessage: response.error?.localizedDescription)
        
        viewController?.displayInitialView(viewModel: viewModel)
    }
    
    func presentLoadMoreView(response: Awaiting.LoadMore.Response) {
        let petitions = response.petitionSimpleInfos.map { simpleInfo -> Awaiting.LoadMore.ViewModel.Petition in
            let currentCategory = response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "= 카테고리 조회실패 ="
            
            return Awaiting.LoadMore.ViewModel.Petition(idx: simpleInfo.idx,
                                                       expirationDate: simpleInfo.expirationDate,
                                                       category: currentCategory,
                                                       title: simpleInfo.title,
                                                       agreeCount: simpleInfo.agreeCount)
        }
        
        let viewModel = Awaiting.LoadMore.ViewModel(petitions: petitions)
        
        viewController?.displayLoadMoreView(viewModel: viewModel)

    }
}
