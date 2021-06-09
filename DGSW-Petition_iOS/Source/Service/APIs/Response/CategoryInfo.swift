//
//  CategoryInfo.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/26.
//

import Foundation

class CategoryInfo: Decodable {
    var idx: Int
    var categoryName: String
    
    init(idx: Int, categoryName: String){
        self.idx = idx
        self.categoryName = categoryName
    }
    
    func toEntity() -> CategoryEntity {
        return CategoryEntity(idx: self.idx, categoryName: self.categoryName)
    }
}
