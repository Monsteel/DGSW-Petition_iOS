//
//  PetitionAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation
import Moya

enum PetitionAPI {
    case getPetitionDetailInfo(_ idx: Int)
    case getPetitionRanking(_ amount: Int)
    case getPetitionSituation
    case getPetitions(_ page: Int,_ size: Int, _ type: PetitionFetchType)
    case searchPetition(_ page: Int,_ size: Int,_ keyword: String)
    case writePetition(_ request: PetitionRequest)
    case editPetition(_ idx:Int, _ request: PetitionRequest)
    case deletePetition(_ idx:Int)
}

extension PetitionAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"petition")!
    }
    
    var path: String {
        switch self {
            case .getPetitionDetailInfo(let idx):
                return "/detail/\(idx)"
            case .getPetitionSituation:
                return "/petition-situation"
            case .getPetitionRanking:
                return "/ranks"
            case .getPetitions:
                return ""
            case .searchPetition:
                return "/search"
            case .writePetition:
                return ""
            case .editPetition(let idx, _):
                return "/\(idx)"
            case .deletePetition(let idx):
                return "/\(idx)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getPetitionDetailInfo:
                return .get
            case .getPetitionSituation:
                return .get
            case .getPetitionRanking:
                return .get
            case .getPetitions:
                return .get
            case .searchPetition:
                return .get
            case .writePetition:
                return .post
            case .editPetition:
                return .put
            case .deletePetition:
                return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getPetitionDetailInfo:
                return .requestPlain
            case .getPetitionSituation:
                return .requestPlain
            case .getPetitionRanking(let amount):
                return .requestParameters(parameters:["amount": amount], encoding: URLEncoding.queryString)
            case let .getPetitions(page, size, type):
                return .requestParameters(parameters:["page": page, "size": size, "type": type.rawValue], encoding: URLEncoding.queryString)
            case let .searchPetition(page, size, keyword):
                return .requestParameters(parameters:["page": page, "size": size, "keyword": keyword], encoding: URLEncoding.queryString)
            case .writePetition(let request):
                return .requestData(try! JSONEncoder().encode(request))
            case .editPetition(_, let request):
                return .requestData(try! JSONEncoder().encode(request))
            case .deletePetition(_):
                return .requestPlain
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        headers["x-access-token"] = KeychainManager.shared.accessToken
        return headers
    }
}
