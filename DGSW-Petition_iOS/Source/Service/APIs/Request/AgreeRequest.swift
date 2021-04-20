//
//  AgreeRequest.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation

class AgreeRequest:Encodable {
    var petitionIdx: Int
    var content: String
    
    init(petitionIdx: Int, content: String){
        self.petitionIdx = petitionIdx
        self.content = content
    }
}
