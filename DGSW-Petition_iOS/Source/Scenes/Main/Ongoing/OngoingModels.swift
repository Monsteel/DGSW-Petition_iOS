//
//  OngoingModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

enum Ongoing
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
            let categoryInfos: [CategoryInfo]?
            let error: Error?
        }

        struct ViewModel
        {
            let petitions: [Petition]?
            let errorMessage: String?
            
            struct Petition {
                var idx: Int
                var expirationDate: Date
                var category: String
                var title: String
                var agreeCount: Int
            }
        }
    }
    
    enum LoadMore
    {
        struct Request
        {
            let page: Int
        }

        struct Response
        {
            let petitionSimpleInfos: [PetitionSimpleInfo]
            let categoryInfos: [CategoryInfo]?
        }

        struct ViewModel
        {
            let petitions: [Petition]
            
            struct Petition {
                var idx: Int
                var expirationDate: Date
                var category: String
                var title: String
                var agreeCount: Int
            }
        }
    }
}
