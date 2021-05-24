//
//  HomeViewDataSource.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//


import Foundation
import UIKit

class HomeViewDataSource: NSObject {
    let sections: [Section]
    
    enum Section {
        case `static`([Item])
        case widget([Item])
        case petition([Item])
    }
    
    enum Item {
        case search(_ delegate: HomeViewSearchCellDelegate)
        case banner
        case widget(_ viewModel: HomeViewWidgetCell.ViewModel?,
                    _ errorMessage: String?,
                    _ delegate: HomeViewWidgetCellDelegate)
        case buttonWidget(_ delegate: HomeViewButtonWidgetCellDelegate)
        case petition(_ viewModel: HomeViewPetitionCell.ViewModel?,
                      _ delegate: HomeViewPetitionCellDelegate)
        
        case emptyPetition(_ viewModel: HomeViewEmptyPetitionCell.ViewModel?,
                           _ delegate: HomeViewEmptyPetitionCellDelegate)
    }
    
    //TODO: 데이터에 맞게 수정필요
    init(delegate: (HomeViewSearchCellDelegate & HomeViewButtonWidgetCellDelegate & HomeViewPetitionCellDelegate & HomeViewEmptyPetitionCellDelegate & HomeViewWidgetCellDelegate),
         homeViewWidgetCellViewModel: HomeViewWidgetCell.ViewModel?,
         homeViewPetitionCellViewModel: [HomeViewPetitionCell.ViewModel]?,
         homeViewWidgetCellErrorMessage: String?,
         homeViewPetitionCellErrorMessage: String?) {
        
        let staticSection = [Section.static([.search(delegate), .banner])]
        let widgetSection = [Section.widget([.widget(homeViewWidgetCellViewModel, homeViewWidgetCellErrorMessage, delegate), .buttonWidget(delegate)])]
        var petitionSection: [Section]
        
        
        //Error Check
        if (homeViewPetitionCellViewModel == nil) {
            let errorMessage = (homeViewPetitionCellErrorMessage != nil) ? "오류가 발생했습니다.\n\(homeViewPetitionCellErrorMessage!)" : "오류가 발생했습니다."
            petitionSection = [Section.petition([.emptyPetition(.init(type: .failedLoad, errorMessage: errorMessage), delegate)])]
        } else if (homeViewPetitionCellViewModel!.isEmpty) {
            petitionSection = [Section.petition([.emptyPetition(.init(type: .justEmpty, errorMessage: "청원이 없습니다."), delegate)])]
        }else {
            petitionSection = [Section.petition( homeViewPetitionCellViewModel!.map { .petition($0, delegate) } )]
        }

        
        self.sections = staticSection + widgetSection + petitionSection
        
        super.init()
    }
}

extension HomeViewDataSource: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentSection = sections[section]
        
        switch currentSection {
            case .`static`(let item):
                return item.count
            case .petition(let item):
                return item.count
            case .widget(let item):
                return item.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSection = sections[indexPath.section]
        switch currentSection {
            case .`static`(let items):
                switch items[indexPath.item] {
                    case let .search(delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewSearchCell.registerId, for: indexPath) as! HomeViewSearchCell
                        cell.delegate = delegate
                        return cell
                    case .banner:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewBannerCell.registerId, for: indexPath) as! HomeViewBannerCell
                        return cell
                    case let .buttonWidget(delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewButtonWidgetCell.registerId, for: indexPath) as! HomeViewButtonWidgetCell
                        cell.delegate = delegate
                        return cell
                    default: fatalError("No items are matched")
                }
            case let .petition(items):
                switch items[indexPath.item] {
                    case let .petition(viewModel, delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewPetitionCell.registerId, for: indexPath) as! HomeViewPetitionCell
                        cell.viewModel = viewModel
                        cell.delegate = delegate
                        return cell
                    case let .emptyPetition(viewModel, delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewEmptyPetitionCell.registerId, for: indexPath) as! HomeViewEmptyPetitionCell
                        cell.viewModel = viewModel
                        cell.delegate = delegate
                        return cell
                    default: fatalError("No items are matched")
                }
            case .widget(let items):
                switch items[indexPath.item] {
                    case let .widget(viewModel, errorMessage, delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewWidgetCell.registerId, for: indexPath) as! HomeViewWidgetCell
                        cell.viewModel = viewModel
                        cell.errorMessage = errorMessage
                        cell.delegate = delegate
                        return cell
                    case let .buttonWidget(delegate):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewButtonWidgetCell.registerId, for: indexPath) as! HomeViewButtonWidgetCell
                        cell.delegate = delegate
                        return cell
                default: fatalError("No items are matched")
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

extension HomeViewDataSource: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = collectionView.frame.width
        let width = maxWidth - 20
        
        let currentSection = sections[indexPath.section]
        
        switch currentSection {
            case .`static`(let items):
                switch items[indexPath.item] {
                    case .search(_):
                        return CGSize(width: width, height: 40)
                    case .banner:
                        return CGSize(width: maxWidth, height: 150)
                    default:
                        fatalError("No items are matched")
                }
            case .widget:
                return CGSize(width: (width/2)-5, height: 100)
            case .petition(let items):
                switch items[indexPath.item] {
                    case .petition:
                        return CGSize(width: width, height: 80)
                    case .emptyPetition:
                        var height = collectionView.frame.height - (40+150+100+35+10+10+5+5+20+5+50)
                        
                        if(height < 200) { height = 200 }
                        
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
            case .static(_):
                return UIEdgeInsets(top: 10, left: 0, bottom:5, right: 0)
            case .petition(_):
                return UIEdgeInsets(top: 10, left: 0, bottom:20, right: 0)
            case .widget(_):
                return UIEdgeInsets(top: 5, left: 10, bottom:5, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if case .petition = sections[section] {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else { return CGSize() }
    }
}
