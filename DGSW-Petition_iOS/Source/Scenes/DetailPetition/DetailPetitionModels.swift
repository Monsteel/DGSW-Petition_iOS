//
//  DetailPetitionModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit

enum DetailPetition
{
    // MARK: Use cases

    enum Refresh
    {
        struct Request
        {
            
        }

        struct Response
        {
            let petitionDetailInfo: PetitionDetailInfo?
            let categoryInfo: CategoryInfo?
            let answerInfos: [AnswerDetailInfo]?
            let error: DetailPetitionError?
        }

        struct ViewModel
        {
            let petiton: Petition?
            let errorMessage: String?
            
            struct Petition {
                var writerID: String
                var createdAt: Date
                var expirationDate: Date
                var category: String
                var title: String
                var content: String
                var agreeCount: Int
                
                var answerContent: [String]?
            }
        }
    }
    
    enum FetchAgree
    {
        struct Request
        {
            let page: Int
        }

        struct Response
        {
            let agreeDetailInfos: [AgreeDetailInfo]?
            let error: DetailPetitionError?
        }

        struct ViewModel
        {
            let answers: [Agree]?
            let errorMessage: String?
            
            struct Agree {
                let writerID: String
                let content: String
            }
        }
    }
    
    enum WriteAgree
    {
        struct Request
        {
            let content: String
        }

        struct Response
        {
            let error: DetailPetitionError?
        }

        struct ViewModel
        {
            let errorMessage: String?
        }
    }
    
    enum WriteAnswer
    {
        struct Request
        {
            let content: String
        }

        struct Response
        {
            let error: DetailPetitionError?
        }

        struct ViewModel
        {
            let errorMessage: String?
        }
    }
}
