//
//  WelcomeInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import UIKit

protocol WelcomeBusinessLogic {
    func checkRegisteredUser(request: Welcome.CheckRegisteredUser.Request)
    func login(request: Welcome.Login.Request)
}

protocol WelcomeDataStore {
    
}

class WelcomeInteractor: WelcomeBusinessLogic, WelcomeDataStore {
    var presenter: WelcomePresentationLogic?
    
    var loginWorker: LoginWorker?
    var registerWorker: RegisterWorker?

    // MARK: Do something (and send response to WelcomePresenter)

    func login(request: Welcome.Login.Request) {
        loginWorker = LoginWorker.shared
        
        let request = LoginRequest(userID: request.userID,
                                   googleToken: request.googleToken)
        
        loginWorker?.login(request) { [weak self] in
            var response = Welcome.Login.Response()
            if case let .failure(err) = $0 { response.error = err }
            self?.presenter?.presentLogin(response: response)
        }
    }
    
    func checkRegisteredUser(request: Welcome.CheckRegisteredUser.Request) {
        registerWorker = RegisterWorker.shared
        
        registerWorker?.checkRegisteredUser(request.userID) { [weak self] in
            var response = Welcome.CheckRegisteredUser.Response(isRegistered: false)
            if case let .success(res) = $0 { response.isRegistered = res }
            if case let .failure(err) = $0 { response.error = err }
            self?.presenter?.presentCheckRegisteredUser(response: response)
        }
    }
}
