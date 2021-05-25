//
//  AnswerWriteModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/24.
//

import UIKit

enum AnswerWrite
{
    // MARK: Use cases

    enum WriteAnswer
    {
        struct Request
        {
            let petitionIdx: Int
            let content: String
        }

        struct Response
        {
            var error: Error?
        }

        struct ViewModel
        {
            let errorMessage: String?
        }
    }
}
