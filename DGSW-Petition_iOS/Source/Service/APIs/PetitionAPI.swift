//
//  PetitionAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation
import Moya

enum PetitionAPI {
    case getPetitions(_ page: String,_ size: String)
    case searchPetition(_ page: String,_ size: String,_ keyword: String)
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
            case .getPetitions(_, _):
                return ""
            case .searchPetition(_, _, _):
                return "/search"
            case .writePetition(_):
                return ""
            case .editPetition(let idx, _):
                return "/\(idx)"
            case .deletePetition(let idx):
                return "/\(idx)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getPetitions(_, _):
                return .get
            case .searchPetition(_, _, _):
                return .get
            case .writePetition(_):
                return .post
            case .editPetition(_, _):
                return .put
            case .deletePetition(_):
                return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getPetitions(page, size):
            return .requestParameters(parameters:["page": page, "size": size], encoding: URLEncoding.queryString)
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
        headers["x-access-token"] = AuthLocal.shared.selectToken()?.accessToken
        return headers
    }
}
