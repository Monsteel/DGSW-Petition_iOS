//
//  PetitionDetailInfo.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation

class PetitionDetailInfo: Decodable {
    var idx: Int
    var writerID: String
    var createdAt: Date
    var expirationDate: Date
    var category: String
    var title: String
    var content: String
    
    var fKeyword: String?
    var sKeyword: String?
    var tKeyword: String?
    
    var agreeCount: Int
    var isAnswer: Bool
}
