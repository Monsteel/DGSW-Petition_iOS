//
//  AuthLocal.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import RealmSwift

class AuthLocal: DGSW_Petition_iOS.Local {
    private lazy var realm: Realm! = getReam()
    
    func saveToken(_ tokenEntity: TokenEntity?, res: (Result<Void, Error>) -> Void) {
        guard let tokenEntity = tokenEntity else {
            res(Result.failure(CustomError.error(message: "토큰 저장 실패", keys: [.retry])))
            return
        }
        
        do{
            try self.realm.write {
                self.realm.delete(self.realm.objects(TokenEntity.self))
                self.realm.add(tokenEntity)
            }
            res(Result.success(Void()))
        }
        catch{
            res(Result.failure(CustomError.error(message: "토큰 저장 실패", keys: [.retry])))
        }
    }

}
