//
//  CompletedInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol CompletedBusinessLogic {
    func doSomething(request: Completed.Something.Request)
}

protocol CompletedDataStore {
    
}

class CompletedInteractor: CompletedBusinessLogic, CompletedDataStore {
    var presenter: CompletedPresentationLogic?
//    var worker: CompletedWorker?

    // MARK: Do something (and send response to CompletedPresenter)

    func doSomething(request: Completed.Something.Request) {
//        worker = CompletedWorker()
//        worker?.doSomeWork()

        let response = Completed.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
}
