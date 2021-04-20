//
//  PetitionRequest.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation

class PetitionRequest: Encodable {
    var category: String
    var title: String
    var content: String
    var firstKeyword: String?
    var secondKeyword: String?
    var thirdKeyword: String?
    
    init(category: String,
         title: String,
         content: String,
         firstKeyword: String?,
         secondKeyword: String?,
         thirdKeyword: String?){
        self.category = category
        self.title = title
        self.content = content
        self.firstKeyword = firstKeyword
        self.secondKeyword = secondKeyword
        self.thirdKeyword = thirdKeyword
    }
}
