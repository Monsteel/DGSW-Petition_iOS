//
//  AgreeDetailInfo.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/21.
//

import Foundation

class AgreeDetailInfo: Decodable {
    var idx: Int
    var petitionIdx: Int
    var writerID: String
    var createdAt: Date
    var content:String
}
