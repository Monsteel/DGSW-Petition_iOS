//
//  UserEntity.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation

import Foundation
import RealmSwift

class UserEntity: Object {
    @objc
    dynamic var idx: Int = -1
    
    @objc
    dynamic var userID: String?
    
    @objc
    dynamic var permissionType: String?
    
    @objc
    dynamic var createdAt: Date?
    
    convenience required init(idx: Int,
                              userID: String,
                              permissionType: PermissionType,
                              createdAt: Date){
        self.init()
        self.idx = idx
        self.userID = userID
        self.permissionType = permissionType.rawValue
        self.createdAt = createdAt
    }
    
    func toModel() -> UserDetailInfo {
        return UserDetailInfo(idx: self.idx,
                              userID: self.userID!,
                              permissionType: PermissionType(rawValue: self.permissionType!)!,
                              createdAt: self.createdAt!)
    }
}
