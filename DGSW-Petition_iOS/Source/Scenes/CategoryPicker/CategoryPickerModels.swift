//
//  CategoryPickerModels.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit

enum CategoryPicker
{
    // MARK: Use cases

    enum Refresh
    {
        struct Request
        {

        }

        struct Response
        {
            let categoryInfos: [CategoryInfo]?
            let error: CategoryPickerError?
        }

        struct ViewModel
        {
            let categories: [Category]?
            let errorMessage: String?
            
            struct Category {
                let idx: Int
                let categoryName: String
            }
        }
    }
}
