//
//  Worker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya

class Worker<T: TargetType, L: DGSW_Petition_iOS.Local> {
    let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
    let local = L()
}

class ApiWorker<T: TargetType> {
    let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
}

class LocalWorker<L: DGSW_Petition_iOS.Local> {
    let local = L()
}
