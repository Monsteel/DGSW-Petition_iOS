//
//  RegisterInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/22.
//

import UIKit

protocol RegisterBusinessLogic {
    func register(request: Register.Register.Request)
}

protocol RegisterDataStore {
    
}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore {
    var presenter: RegisterPresentationLogic?
    var worker: RegisterWorker?
    
    // MARK: Do something (and send response to RegisterPresenter)

    func register(request: Register.Register.Request) {
        worker = RegisterWorker.shared

        worker?.register(RegisterRequest(permissionKey: request.permissionKey,
                                         userID: request.userID,
                                         googleToken: request.googleToken)) { [weak self] in
            var response = Register.Register.Response()
            if case let .failure(err) = $0 { response.error = err }
            self?.presenter?.presentRegister(response: response)
        }
    }
    
}
