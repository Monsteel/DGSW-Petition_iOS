//
//  UserDetailInfo.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation

class UserDetailInfo: Decodable {
    var idx: Int?
    var userID: String?
    var permissionType: PermissionType?
    var createdAt: Date?
    
    
    enum Key : String, CodingKey{
        case idx
        case userID
        case permissionType
        case createdAt
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: Key.self)
        
        self.idx = try container.decodeIfPresent(Int.self, forKey: .idx)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.permissionType = .init(rawValue: try container.decode(String.self, forKey: .permissionType))
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
    }
    
    init(){}
    
    init(idx: Int, userID: String, permissionType: PermissionType, createdAt: Date){
        self.idx = idx
        self.userID = userID
        self.permissionType = permissionType
        self.createdAt = createdAt
    }
    
    func toEntity() -> UserEntity {
        return UserEntity(idx: self.idx ?? -1,
                          userID: self.userID ?? "",
                          permissionType: self.permissionType ?? .STUDENT,
                          createdAt: self.createdAt ?? Date())
    }
}
