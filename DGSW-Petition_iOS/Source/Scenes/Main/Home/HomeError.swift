//
//  HomeError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/18.
//

import Foundation

enum HomeError: Error {
    case getPetitionSituationError(message: String)
    case getTopTenPetitionError(message: String)
}
