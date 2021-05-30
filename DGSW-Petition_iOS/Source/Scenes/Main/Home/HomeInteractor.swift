//
//  HomeInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol HomeBusinessLogic {
    func refresh(request: Home.Refresh.Request)
}

protocol HomeDataStore {
    
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?
    
    // MARK: Do something (and send response to HomePresenter)
    
    func refresh(request: Home.Refresh.Request) {
        getPetitionSituation()
        getTopTenPetition()
    }
    
    private func getPetitionSituation() {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitionSituation { [weak self] in
            switch $0 {
                case .success(let res):
                    self?.presentPetitionSituation(nil, res.data)
                case .failure(let err):
                    self?.presentPetitionSituation(err.toHomeError(.FailPetitionSituation), nil)
            }
        }
    }
    
    private func getTopTenPetition() {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getTopTenPetition { [weak self] in
            switch $0 {
                case .success(let res):
                    self?.getCategories(res.data)
                case .failure(let err):
                    self?.presentTopTenPetition(err.toHomeError(.FailTopTenPetition), nil, nil)
            }
        }
    }
    
    private func getCategories(_ petitionSimpleInfo: [PetitionSimpleInfo]) {
        categoryWorker = CategoryWorker.shared
        
        categoryWorker?.getCategories() { [weak self] in
            switch $0 {
                case .success(let infos):
                    self?.presentTopTenPetition(nil, petitionSimpleInfo, infos)
                case .failure:
                    self?.presentTopTenPetition(nil, petitionSimpleInfo, [])
            }
        }
    }
}

extension HomeInteractor {
    private func presentTopTenPetition(_ error: HomeError?,
                                       _ petitionSimpleInfo: [PetitionSimpleInfo]?,
                                       _ categoryInfos: [CategoryInfo]?) {
        let response = Home.Refresh.Response(petitionSimpleInfos: petitionSimpleInfo,
                                             petitionSituationInfo: nil,
                                             categoryInfos: categoryInfos,
                                             petitionSimpleInfosError: error,
                                             petitionSituationInfoError: nil)
        presenter?.presentTopTenPetition(response: response)
    }
    
    private func presentPetitionSituation(_ error: HomeError?,
                                          _ petitionSituationInfo: PetitionSituationInfo?) {
        let response = Home.Refresh.Response(petitionSimpleInfos: nil,
                                             petitionSituationInfo: petitionSituationInfo,
                                             categoryInfos: nil,
                                             petitionSimpleInfosError: nil,
                                             petitionSituationInfoError: error)
        
        presenter?.presentPetitionSituation(response: response)
    }
}
