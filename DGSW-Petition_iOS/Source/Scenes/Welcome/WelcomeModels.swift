//
//  WelcomeModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import UIKit

enum Welcome
{
    // MARK: Use cases

    enum Login
    {
        struct Request
        {
            var userID: String
            var googleToken: String
        }

        struct Response
        {
            var error: Error?
        }

        struct ViewModel
        {
            var errorMessage: String?
        }
    }
    
    enum CheckRegisteredUser
    {
        struct Request
        {
            var userID: String
        }

        struct Response
        {
            var error: Error?
            var isRegistered: Bool
        }

        struct ViewModel
        {
            var isRegistered: Bool
            var errorMessage: String?
        }
    }
}
