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
    var worker: PetitionWorker?
    
    // MARK: Do something (and send response to HomePresenter)
    
    func refresh(request: Home.Refresh.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitionSituation { [weak self] in
            switch $0 {
                case .success(let petitionSituationResponse):
                    self?.worker?.getTopTenPetition { [weak self] in
                        switch $0 {
                            case .success(let topTenPetitionResponse):
                                let resposne = Home.Refresh.Response(petitionSimpleInfos: topTenPetitionResponse.data,
                                                                     petitionSituationInfo: petitionSituationResponse.data,
                                                                     error: nil)
                                
                                self?.presenter?.presentInitialView(response: resposne)
                            case .failure(let err):
                                let resposne = Home.Refresh.Response(petitionSimpleInfos: nil,
                                                                     petitionSituationInfo: nil,
                                                                     error: HomeError.getTopTenPetitionError(message: err.localizedDescription))
                                
                                self?.presenter?.presentInitialView(response: resposne)
                        }
                    }
                case .failure(let err):
                    let resposne = Home.Refresh.Response(petitionSimpleInfos: nil,
                                                         petitionSituationInfo: nil,
                                                         error: HomeError.getPetitionSituationError(message: err.localizedDescription))
                    
                    self?.presenter?.presentInitialView(response: resposne)
            }
        }
    }
}
