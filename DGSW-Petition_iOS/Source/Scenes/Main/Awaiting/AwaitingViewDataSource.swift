//
//  AwaitingViewDataSource.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/22.
//

import Foundation
import UIKit

class AwaitingViewDataSource: NSObject {
    var sections: [Section]
    let delegate: AwaitingViewDataSourceDelegate?
    var currentPageCount: Int = 0
    var isFinishLoad: Bool = false
    var isLoadingMore: Bool = false
    
    enum Section {
        case petition([Item])
    }
    
    enum Item {
        case petition(_ viewModel: AwaitingViewPetitionCell.ViewModel?,
                      _ delegate: AwaitingViewPetitionCellDelegate)
        
        case emptyPetition(_ viewModel: AwaitingViewEmptyPetitionCell.ViewModel?,
                           _ delegate: AwaitingViewEmptyPetitionCellDelegate)
    }
    
    
    init(delegate: (AwaitingViewPetitionCellDelegate & AwaitingViewEmptyPetitionCellDelegate & AwaitingViewDataSourceDelegate),
         awaitingViewPetitionCellViewModel: [AwaitingViewPetitionCell.ViewModel]?,
         awaitingViewPetitionCellErrorMessage: String?) {
        
        let petitionSection: [Section]
        //Error Check
        if (awaitingViewPetitionCellViewModel == nil) {
            let errorMessage = (awaitingViewPetitionCellErrorMessage != nil) ? "오류가 발생했습니다.\n\(awaitingViewPetitionCellErrorMessage!)" : "오류가 발생했습니다."
            petitionSection = [Section.petition([.emptyPetition(.init(type: .failedLoad, errorMessage: errorMessage), delegate)])]
        } else if (awaitingViewPetitionCellViewModel!.isEmpty) {
            petitionSection = [Section.petition([.emptyPetition(.init(type: .justEmpty, errorMessage: "청원이 없습니다."), delegate)])]
        }else {
            petitionSection = [Section.petition( awaitingViewPetitionCellViewModel!.map { .petition($0, delegate) } )]
        }
        
        self.sections = petitionSection
        self.delegate = delegate
        
        super.init()
    }
    
    func loadMore(delegate: AwaitingViewPetitionCellDelegate,
                  awaitingViewPetitionCellViewModel: [AwaitingViewPetitionCell.ViewModel]) {
        currentPageCount = currentPageCount + 1
        
        self.isFinishLoad = awaitingViewPetitionCellViewModel.isEmpty
        if(self.isFinishLoad) { return }
        
        self.sections.append(contentsOf: [Section.petition( awaitingViewPetitionCellViewModel.map { .petition($0, delegate) } )])
    }
}

extension AwaitingViewDataSource: UICollectionViewDataSource {
    
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
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AwaitingViewPetitionCell.registerId, for: indexPath) as! AwaitingViewPetitionCell
                        cell.viewModel = viewModel
                        cell.delegate = delegate
                        return cell
                    case let .emptyPetition(viewModel, delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AwaitingViewEmptyPetitionCell.registerId, for: indexPath) as! AwaitingViewEmptyPetitionCell
                        cell.viewModel = viewModel
                        cell.delegate = delegate
                        return cell
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: HomeViewPetitionHeader.registerId,
                                                                                 for: indexPath) as? HomeViewPetitionHeader ?? UICollectionReusableView()
                return headerView
            default: preconditionFailure("Invalid supplementary view type for this collection view")
        }
    }
}

extension AwaitingViewDataSource: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
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
                        return CGSize(width: width, height: collectionView.frame.height)
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = sections[section]
        
        switch section {
            case .petition:
                return UIEdgeInsets(top: 10, left: 0, bottom:20, right: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll(scrollView)
    }
}

protocol AwaitingViewDataSourceDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}
