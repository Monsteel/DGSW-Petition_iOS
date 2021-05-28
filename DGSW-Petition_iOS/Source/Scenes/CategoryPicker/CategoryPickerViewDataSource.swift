//
//  CategoryPickerViewDataSource.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/27.
//

import UIKit

class CategoryPickerViewDataSource: NSObject {
    let sections: [Section]
    
    var delegate: CategoryPickerViewDataSourceDelegate?
    
    enum Section {
        case category([Item])
    }
    
    enum Item {
        case category(_ viewModel: CategoryPickerViewCategoryCell.ViewModel)
    }
    
    //TODO: 데이터에 맞게 수정필요
    init(categories: [CategoryPickerViewCategoryCell.ViewModel],
         delegate: CategoryPickerViewDataSourceDelegate) {
        let items = categories.map { Item.category(.init(idx: $0.idx, categoryName: $0.categoryName, isSelected: $0.isSelected)) }
        
        self.sections = [Section.category(items)]
        self.delegate = delegate
        
        super.init()
    }
}



extension CategoryPickerViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        
        switch currentSection {
            case .category(let items):
                return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let currentSection = sections[indexPath.section]
        switch currentSection {
            case .category(let items):
                switch items[indexPath.item] {
                    case let .category(viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryPickerViewCategoryCell.registerId) as! CategoryPickerViewCategoryCell
                        cell.viewModel = viewModel
                        return cell
                }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}

extension CategoryPickerViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath.section]
        switch currentSection {
            case .category(let items):
                switch items[indexPath.item] {
                    case let .category(viewModel):
                        self.delegate?.onClickCategoryCell(viewMdoel: viewModel)
                        tableView.deselectRow(at: indexPath, animated: true)
                }
        }
    }
}

protocol CategoryPickerViewDataSourceDelegate {
    func onClickCategoryCell(viewMdoel: CategoryPickerViewCategoryCell.ViewModel)
}

