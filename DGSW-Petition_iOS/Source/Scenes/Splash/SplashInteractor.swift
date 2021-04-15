//
//  SplashInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/15.
//

protocol SplashBusinessLogic {

}

protocol SplashDataStore {
    
}

class SplashInteractor:SplashBusinessLogic, SplashDataStore {
    var presenter: SplashPresentationLogic?
    
}
