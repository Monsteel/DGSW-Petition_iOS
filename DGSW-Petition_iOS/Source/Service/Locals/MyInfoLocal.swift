//
//  UserLocal.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation
import RealmSwift

class MyInfoLocal: DGSW_Petition_iOS.Local {
    static var shared = MyInfoLocal()
    private lazy var realm: Realm! = getRealm()
    
    func insertUser(_ userEntity: UserEntity?, res: (Result<Void, Error>) -> Void) {
        guard let userEntity = userEntity else {
            res(.failure(PTCoreDataError(tableName: UserEntity.tableName, type: .saveFail)) )
            return
        }
        
        do{
            try self.realm.write {
                self.realm.delete(self.realm.objects(UserEntity.self))
                self.realm.add(userEntity)
            }
            res(.success(Void()))
        }
        catch{
            res(.failure(PTCoreDataError(tableName: UserEntity.tableName, type: .saveFail)) )
        }
    }
    
    func selectUser(res: (Result<UserEntity, Error>) -> Void) {
        let userEntity = realm.objects(UserEntity.self).first
        
        if(userEntity == nil) {
            res(.failure(PTCoreDataError(tableName: UserEntity.tableName, type: .empty)) )
        }else {
            res(.success(userEntity!))
        }
    }
}
