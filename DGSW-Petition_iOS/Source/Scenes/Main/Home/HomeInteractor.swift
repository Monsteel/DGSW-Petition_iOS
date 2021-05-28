//
//  HomeInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol HomeBusinessLogic {
    func refresh(request: Home.Refresh.Request)
//    func refreshTopTenPetitions(request: Home.Refresh.Request)
}

protocol HomeDataStore {
    
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?
    
    // MARK: Do something (and send response to HomePresenter)
    
    func refresh(request: Home.Refresh.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitionSituation { [weak self] in
            switch $0 {
                case .success(let petitionSituationResponse):
                    self?.getTopTenPetition(petitionSituationResponse.data)
                case .failure(let err):
                    let err = HomeError.getPetitionSituationError(message: err.localizedDescription)
                    self?.presentInitialView(nil, nil, nil, err)
            }
        }
    }
    
    private func getTopTenPetition(_ petitionSituationResponse: PetitionSituationInfo) {
        petitionWorker?.getTopTenPetition { [weak self] in
            switch $0 {
                case .success(let topTenPetitionResponse):
                    self?.getCategories(petitionSituationResponse, topTenPetitionResponse.data)
                case .failure(let err):
                    let err = HomeError.getTopTenPetitionError(message: err.localizedDescription)
                    self?.presentInitialView(petitionSituationResponse, nil, nil, err)
            }
        }
    }
    
    private func getCategories(_ petitionSituationResponse: PetitionSituationInfo, _ petitionSimpleInfos: [PetitionSimpleInfo]){
        categoryWorker = CategoryWorker.shared
        
        categoryWorker?.getCategories() { [weak self] in
            switch $0 {
                case .success(let categoryInfos):
                    self?.presentInitialView(petitionSituationResponse, petitionSimpleInfos, categoryInfos, nil)
                case .failure(let err):
                    self?.presentInitialView(petitionSituationResponse, petitionSimpleInfos, nil, err)
            }
        }
    }
}

extension HomeInteractor {
    private func presentInitialView(_ petitionSituationInfo: PetitionSituationInfo?, _ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?, _ error: Error?){
        let resposne = Home.Refresh.Response(petitionSimpleInfos: petitionSimpleInfos,
                                             petitionSituationInfo: petitionSituationInfo,
                                             categoryInfos: categoryInfos,
                                             error: error)
        
        self.presenter?.presentInitialView(response: resposne)
    }
}
