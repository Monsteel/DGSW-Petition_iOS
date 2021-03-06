//
//  HomeModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

enum Home
{
    // MARK: Use cases

    enum Refresh
    {
        struct Request
        {
            //NOTTING
        }

        struct Response
        {
            let petitionSimpleInfos: [PetitionSimpleInfo]?
            let petitionSituationInfo: PetitionSituationInfo?
            let categoryInfos: [CategoryInfo]?
            
            let petitionSimpleInfosError: HomeError?
            let petitionSituationInfoError: HomeError?
        }

        struct ViewModel
        {
            let topTenPetitions: [Petition]?
            let petitionSituation: PetitionSituation?
            let errorMessage:String?
            
            struct Petition {
                var idx: Int
                var expirationDate: Date
                var category: String
                var title: String
                var agreeCount: Int
            }
            
            struct PetitionSituation {
                var agreeCount: Int
                var completedCount: Int
                var awaitingCount: Int
            }
        }
    }
}
