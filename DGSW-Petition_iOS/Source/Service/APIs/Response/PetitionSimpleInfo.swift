//
//  PetitionSimpleInfo.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation

class PetitionSimpleInfo:Decodable {
    var idx: Int
    var expirationDate: Date
    var category: Int
    var title: String
    var agreeCount: Int
    var isAnswer: Bool
}
