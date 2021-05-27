//
//  CategoryPickerViewCategoryCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit

class CategoryPickerViewCategoryCell: UITableViewCell {
    static let registerId = "\(CategoryPickerViewCategoryCell.self)"
    
    struct ViewModel {
        let idx: Int
        let categoryName: String
        let isSelected: Bool
    }
    
    //MARK: - properties
    
    var viewModel: ViewModel! {
        didSet {
            self.categoryNameLabel.text = viewModel.categoryName
            if (viewModel.isSelected) {
                self.categoryNameLabel.textColor = .systemBlue
            }
        }
    }
    
    //MARK: - UI
    
    lazy var categoryNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(categoryNameLabel)
        
        categoryNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
