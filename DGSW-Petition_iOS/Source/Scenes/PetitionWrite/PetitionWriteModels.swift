//
//  PetitionWriteModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

enum PetitionWrite
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
            let error: PetitionWriteError?
        }

        struct ViewModel
        {
            let petition: Petition?
            let errorMessage: String?
            
            struct Petition {
                let title: String
                let categoryName: String
                let content: String
                let fKeyword: String?
                let sKeyword: String?
                let tKeyword: String?
            }
        }
    }
    
    enum WritePetition
    {
        struct Request
        {
            let title: String
            let content: String
            let fkeyword: String
            let skeyword: String
            let tkeyword: String
        }

        struct Response
        {
            let error: PetitionWriteError?
        }

        struct ViewModel
        {
            let errorMessage: String?
        }
    }
    
    enum ModifyPetition
    {
        struct Request
        {
            let title: String
            let content: String
            let fkeyword: String
            let skeyword: String
            let tkeyword: String
        }

        struct Response
        {
            let error: PetitionWriteError?
        }

        struct ViewModel
        {
            let errorMessage: String?
        }
    }
}
