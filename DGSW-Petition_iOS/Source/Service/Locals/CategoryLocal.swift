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
            res(.failure(CoreDataError(tableName: "Category", type: .saveFail)))
            return
        }
        
        do{
            try self.realm.write {
                self.realm.delete(self.realm.objects(CategoryEntity.self))
                self.realm.add(categoryEntities)
            }
            res(.success(Void()))
        }
        catch{
            res(.failure(CoreDataError(tableName: "Category", type: .saveFail)))
        }
    }
    
    func selectCategories(res: (Result<[CategoryEntity], Error>) -> Void) {
        let categoryEntities = Array(realm.objects(CategoryEntity.self))
        
        if(categoryEntities.isEmpty) {
            res(.failure(CoreDataError(tableName: "Category", type: .empty)))
        }else {
            res(.success(categoryEntities))
        }
    }
    
    func selectCategory(_ idx: Int, res: (Result<CategoryEntity, Error>) -> Void) {
        if let categoryEntiy = selectCategoryByPredicate(predicate: NSPredicate(format: "idx == %@", idx)) {
            res(.success(categoryEntiy))
        }else {
            res(.failure(CoreDataError(tableName: "Category", type: .empty)))
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

