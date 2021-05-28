//
//  CategoryEntity.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/26.
//

import Foundation

import Foundation
import RealmSwift

class CategoryEntity: Object {
    @objc
    dynamic var idx: Int = -1
    
    @objc
    dynamic var categoryName: String?
    
    convenience required init(idx: Int,
                              categoryName: String){
        self.init()
        self.idx = idx
        self.categoryName = categoryName
    }
    
    func toModel() -> CategoryInfo {
        return CategoryInfo(idx: self.idx, categoryName: self.categoryName!)
    }
}
