//
//  SearchViewDataSource.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import Foundation
import UIKit

class SearchViewDataSource: NSObject {
    var sections: [Section]
    let delegate: SearchViewDataSourceDelegate?
    var currentPageCount: Int = 0
    var isFinishLoad: Bool = false
    var isLoadingMore: Bool = false
    
    enum Section {
        case petition([Item])
    }
    
    enum Item {
        case petition(_ viewModel: SearchViewPetitionCell.ViewModel?,
                      _ delegate: SearchViewPetitionCellDelegate)
        case emptyPetition(_ viewModel: SearchViewEmptyPetitionCell.ViewModel?)
    }
    
    //TODO: 데이터에 맞게 수정필요
    init(delegate: (SearchViewPetitionCellDelegate & SearchViewDataSourceDelegate),
         searchViewPetitionCellViewModel: [SearchViewPetitionCell.ViewModel]?,
         errorMessage: String?,
         searchKeyword: String) {
        
        var petitionSection: [Section]
        
        //Error Check
        if (searchViewPetitionCellViewModel == nil) {
            let errorMessage = (errorMessage != nil) ? "오류가 발생했습니다.\n\(errorMessage!)" : "오류가 발생했습니다."
            petitionSection = [Section.petition([.emptyPetition(.init(type: .failedLoad, errorMessage: errorMessage))])]
        } else if (searchViewPetitionCellViewModel!.isEmpty) {
            petitionSection = [Section.petition([.emptyPetition(.init(type: .justEmpty, errorMessage: "청원이 없습니다."))])]
        }else {
            petitionSection = [Section.petition( searchViewPetitionCellViewModel!.map { .petition($0, delegate) } )]
        }

        self.delegate = delegate
        self.sections = petitionSection
        
        super.init()
    }
    
    func loadMore(delegate: SearchViewPetitionCellDelegate,
                  searchViewPetitionCellViewModel: [SearchViewPetitionCell.ViewModel]) {
        currentPageCount = currentPageCount + 1
        
        self.isFinishLoad = searchViewPetitionCellViewModel.isEmpty
        if(self.isFinishLoad) { return }
        
        self.sections.append(contentsOf: [Section.petition( searchViewPetitionCellViewModel.map { .petition($0, delegate) } )])
    }
}

extension SearchViewDataSource: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentSection = sections[section]
        
        switch currentSection {
            case .petition(let item):
                return item.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSection = sections[indexPath.section]
        switch currentSection {
            case let .petition(items):
                switch items[indexPath.item] {
                    case let .petition(viewModel, delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewPetitionCell.registerId, for: indexPath) as! SearchViewPetitionCell
                        cell.viewModel = viewModel
                        cell.delegate = delegate
                        return cell
                    case let .emptyPetition(viewModel):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewEmptyPetitionCell.registerId, for: indexPath) as! SearchViewEmptyPetitionCell
                        cell.viewModel = viewModel
                        return cell
                    default: fatalError("No items are matched")
                }
        }
    }
}

extension SearchViewDataSource: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = collectionView.frame.width
        let width = maxWidth - 20
        
        let currentSection = sections[indexPath.section]
        
        switch currentSection {
            case .petition(let items):
                switch items[indexPath.item] {
                    case .petition:
                        return CGSize(width: width, height: 80)
                    case .emptyPetition:
                        let height = collectionView.frame.height - (40+10+5+10+20)
                        return CGSize(width: width, height: height)
                    default:
                        fatalError("No items are matched")
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = sections[section]
        
        switch section {
            case .petition(_):
                return UIEdgeInsets(top: 10, left: 0, bottom:20, right: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll(scrollView)
    }
}

protocol SearchViewDataSourceDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}
