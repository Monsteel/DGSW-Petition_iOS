//
//  CategoryPickerPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit

protocol CategoryPickerPresentationLogic {
    func presentCategories(response: CategoryPicker.Refresh.Response)
}

class CategoryPickerPresenter: CategoryPickerPresentationLogic {
    weak var viewController: CategoryPickerDisplayLogic?

    // MARK: Parse and calc respnse from CategoryPickerInteractor and send simple view model to CategoryPickerViewController to be displayed

    func presentCategories(response: CategoryPicker.Refresh.Response) {
        let categories = response.categoryInfos?.map { CategoryPicker.Refresh.ViewModel.Category(idx: $0.idx, categoryName: $0.categoryName) }
        let viewModel = CategoryPicker.Refresh.ViewModel(categories: categories, errorMessage: response.error?.localizedDescription)
        
        viewController?.displayInitialView(viewModel: viewModel)
    }
    
}
