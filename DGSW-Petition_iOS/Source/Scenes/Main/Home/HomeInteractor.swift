//
//  HomeInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol HomeBusinessLogic {
    func doSomething(request: Home.Something.Request)
}

protocol HomeDataStore {
    
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
//    var worker: HomeWorker?

    // MARK: Do something (and send response to HomePresenter)

    func doSomething(request: Home.Something.Request) {
//        worker = HomeWorker()
//        worker?.doSomeWork()

        let response = Home.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
}
