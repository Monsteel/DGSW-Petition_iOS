//
//  AnswerDetailInfo.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/21.
//

import Foundation

class AnswerDetailInfo: Decodable {
    var idx: Int
    var petitionIdx: Int
    var userID: String
    var createdAt: Date
    var content:String
}
