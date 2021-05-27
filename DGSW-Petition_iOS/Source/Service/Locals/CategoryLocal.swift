//
//  CategoryLocal.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/26.
//

import Foundation
import RealmSwift

class CategoryLocal: DGSW_Petition_iOS.Local {
    static var shared = CategoryLocal()
    private lazy var realm: Realm! = getRealm()
    
    func insertCategory(_ categoryEntities: [CategoryEntity]?, res: (Result<Void, Error>) -> Void) {
        guard let categoryEntities = categoryEntities else {
            res(Result.failure(CustomError.error(message: "카테고리 저장 실패", keys: [.retry])))
            return
        }
        
        do{
            try self.realm.write {
                self.realm.delete(self.realm.objects(CategoryEntity.self))
                self.realm.add(categoryEntities)
            }
            res(Result.success(Void()))
        }
        catch{
            res(Result.failure(CustomError.error(message: "카테고리 저장 실패", keys: [.retry])))
        }
    }
    
    func selectCategories(res: (Result<[CategoryEntity], Error>) -> Void) {
        let categoryEntities = Array(realm.objects(CategoryEntity.self))
        
        if(categoryEntities.isEmpty) {
            res(.failure(CustomError.error(message: "카테고리 없음", keys: [.basic])))
        }else {
            res(.success(categoryEntities))
        }
    }
    
    func selectCategory(_ idx: Int, res: (Result<CategoryEntity, Error>) -> Void) {
        if let categoryEntiy = selectCategoryByPredicate(predicate: NSPredicate(format: "idx == %@", idx)) {
            res(.success(categoryEntiy))
        }else {
            res(.failure(CustomError.error(message: "카테고리 없음", keys: [.basic])))
        }
    }
}

extension CategoryLocal {
    private func selectCategoryByPredicate(predicate: NSPredicate) -> CategoryEntity? {
        let categories = realm.objects(CategoryEntity.self).filter(predicate)
        if categories.count > 0{
            return categories.first! as CategoryEntity
        }
        else {
            return nil
        }
    }
}

