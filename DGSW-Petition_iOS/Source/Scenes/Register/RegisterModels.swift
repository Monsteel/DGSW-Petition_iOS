//
//  RegisterModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/22.
//

import UIKit

enum Register
{
    // MARK: Use cases

    enum Register
    {
        struct Request
        {
            var permissionKey: String
        }

        struct Response
        {
            var error: RegisterError?
        }

        struct ViewModel
        {
            var errorMessage: String?
        }
    }
    
//    enum SomethingElse
//    {
//        struct Request
//        {
//
//        }
//
//        struct Response
//        {
//
//        }
//
//        struct ViewModel
//        {
//
//        }
//    }
}
