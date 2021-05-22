//
//  OngoingInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol OngoingBusinessLogic {
    func doSomething(request: Ongoing.Something.Request)
}

protocol OngoingDataStore {
    
}

class OngoingInteractor: OngoingBusinessLogic, OngoingDataStore {
    var presenter: OngoingPresentationLogic?
//    var worker: OngoingWorker?

    // MARK: Do something (and send response to OngoingPresenter)

    func doSomething(request: Ongoing.Something.Request) {
//        worker = OngoingWorker()
//        worker?.doSomeWork()

        let response = Ongoing.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
}
