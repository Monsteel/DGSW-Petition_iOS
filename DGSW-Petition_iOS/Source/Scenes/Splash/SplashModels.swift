//
//  SplashModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import UIKit

enum Splash
{
    // MARK: Use cases

    enum Refresh
    {
        struct Request
        {
            
        }

        struct Response
        {
            let error: SplashError?
        }

        struct ViewModel
        {
            let errorMessage: String?
        }
    }
}
