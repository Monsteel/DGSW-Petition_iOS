//
//  AwaitingInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol AwaitingBusinessLogic {
    func doSomething(request: Awaiting.Something.Request)
}

protocol AwaitingDataStore {
    
}

class AwaitingInteractor: AwaitingBusinessLogic, AwaitingDataStore {
    var presenter: AwaitingPresentationLogic?
//    var worker: AwaitingWorker?

    // MARK: Do something (and send response to AwaitingPresenter)

    func doSomething(request: Awaiting.Something.Request) {
//        worker = AwaitingWorker()
//        worker?.doSomeWork()

        let response = Awaiting.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
}
