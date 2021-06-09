//
//  CategoryPickerInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit

protocol CategoryPickerBusinessLogic {
    func refresh(request: CategoryPicker.Refresh.Request)
}

protocol CategoryPickerDataStore {
    var selectedCategoryIdx: Int? { get set }
}

class CategoryPickerInteractor: CategoryPickerBusinessLogic, CategoryPickerDataStore {
    var presenter: CategoryPickerPresentationLogic?
    var categoryWorker: CategoryWorker?
    var selectedCategoryIdx: Int? = nil

    // MARK: Do something (and send response to CategoryPickerPresenter)

    func refresh(request: CategoryPicker.Refresh.Request) {
        categoryWorker = CategoryWorker.shared
        
        categoryWorker?.getCategories() { [weak self] in
            switch $0 {
                case .success(let categories):
                    self?.presetCateogries(categories)
                case .failure(let err):
                    self?.presetCateogries(nil, err.toCategoryPickerError(.FailFetchCategory))
            }
        }
    }
}

extension CategoryPickerInteractor {
    private func presetCateogries(_ categoryInfos: [CategoryInfo]? = nil, _ error: CategoryPickerError? = nil){
        let res = CategoryPicker.Refresh.Response(categoryInfos: categoryInfos, error: error)
        presenter?.presentCategories(response: res)
    }
}
