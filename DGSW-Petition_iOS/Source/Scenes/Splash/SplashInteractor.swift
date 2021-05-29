//
//  SplashInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import UIKit

protocol SplashBusinessLogic {
    func refresh(request: Splash.Refresh.Request)
}

protocol SplashDataStore {
    
}

class SplashInteractor: SplashBusinessLogic, SplashDataStore {
    var presenter: SplashPresentationLogic?
    
    var myInfoWorker: MyInfoWorker?
    var categoryWorker: CategoryWorker?


    
    // MARK: Do something (and send response to SplashPresenter)

    func refresh(request: Splash.Refresh.Request) {
        myInfoWorker = MyInfoWorker.shared
        categoryWorker = CategoryWorker.shared
        
        if(!KeychainManager.shared.isLoged){
            presentRefrestResult(SplashError.UnAuthorized)
            return
        }
        
        myInfoWorker?.insertMyInfo() { [weak self] in
            switch $0 {
                case .success:
                    self?.categoryWorker?.insertCategories() {
                        switch $0 {
                            case .success:
                                self?.presentRefrestResult()
                            case .failure(let err):
                                if let err = err as? NetworkError, (err.statusCode == 410 || err.statusCode == 401) {
                                    self?.presentRefrestResult(SplashError.UnAuthorized)
                                } else {
                                    self?.presentRefrestResult(SplashError.FailCategoryInfo)
                                }
                        }
                    }
                case .failure(let err):
                    if let err = err as? NetworkError, (err.statusCode == 410 || err.statusCode == 401) {
                        self?.presentRefrestResult(SplashError.UnAuthorized)
                    } else {
                        self?.presentRefrestResult(SplashError.FailCategoryInfo)
                    }
            }
        }
        
    }
    
}

extension SplashInteractor {
    func presentRefrestResult(_ error: SplashError? = nil) {
        let response = Splash.Refresh.Response(error: error)
        presenter?.presentRefrestResult(response: response)
    }
}
