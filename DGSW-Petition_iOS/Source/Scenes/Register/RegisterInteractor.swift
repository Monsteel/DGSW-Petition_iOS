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
    var googleToken: String? { get set }
    var userID: String? { get set }
    var isSuccessRegistered: Bool { get set }
}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore {
    var presenter: RegisterPresentationLogic?
    var worker: RegisterWorker?
    
    var googleToken: String?
    var userID: String?
    var isSuccessRegistered: Bool = false
    
    // MARK: Do something (and send response to RegisterPresenter)

    func register(request: Register.Register.Request) {
        worker = RegisterWorker.shared

        worker?.register(RegisterRequest(permissionKey: request.permissionKey,
                                         userID: userID ?? "",
                                         googleToken: googleToken ?? "")) { [weak self] in
            var response = Register.Register.Response()
            
            switch $0 {
                case .success: self?.isSuccessRegistered = true
                case .failure(let err): response.error = err
            }
            
            self?.presenter?.presentRegister(response: response)
        }
    }
    
}
