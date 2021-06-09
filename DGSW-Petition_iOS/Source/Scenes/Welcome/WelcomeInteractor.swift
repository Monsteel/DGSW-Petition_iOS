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
    var googleToken: String? { get set }
    var userID: String? { get set }
    var isSuccessRegistered: Bool { get set }
}

class WelcomeInteractor: WelcomeBusinessLogic, WelcomeDataStore {
    var presenter: WelcomePresentationLogic?
    
    var loginWorker: LoginWorker?
    var registerWorker: RegisterWorker?
    
    var googleToken: String?
    var userID: String?
    var isSuccessRegistered: Bool = false

    // MARK: Do something (and send response to WelcomePresenter)

    func login(request: Welcome.Login.Request) {
        loginWorker = LoginWorker.shared
        
        let request = LoginRequest(userID: request.userID,
                                   googleToken: request.googleToken)
        
        loginWorker?.login(request) { [weak self] in
            switch $0 {
                case .success:
                    self?.presentLogin()
                case .failure(let err):
                    self?.presentLogin(err.toWelcomeError(.FailLogin))
            }
        }
    }
    
    func checkRegisteredUser(request: Welcome.CheckRegisteredUser.Request) {
        registerWorker = RegisterWorker.shared
        
        //store data
        userID = request.userID
        googleToken = request.googleToken
        
        registerWorker?.checkRegisteredUser(request.userID) { [weak self] in
            if case let .success(res) = $0 { self?.presentCheckRegisteredUser(isRegistered: res) }
            if case let .failure(err) = $0 { self?.presentCheckRegisteredUser(err.toWelcomeError(.FailCheckRegisteredUser)) }
        }
        
    }
}


extension WelcomeInteractor {
    func presentLogin(_ error: WelcomeError? = nil) {
        let response = Welcome.Login.Response(error: error)
        presenter?.presentLogin(response: response)
    }
    
    func presentCheckRegisteredUser(isRegistered: Bool = false, _ error: WelcomeError? = nil) {
        let response = Welcome.CheckRegisteredUser.Response(error: error, isRegistered: isRegistered)
        presenter?.presentCheckRegisteredUser(response: response)
    }
}
