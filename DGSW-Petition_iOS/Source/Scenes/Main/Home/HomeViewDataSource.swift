//
//  HomeViewDataSource.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//


import Foundation
import UIKit


/// The data source associated with a list of photos.
class HomeViewDataSource: NSObject {
    let sections: [Section]
    
    enum Section {
        case `static`([Item])
        case widget([Item])
        case petition([Item])
    }
    
    enum Item {
        case search(handler: (String) -> Void)
        case banner
        case widget
        case buttonWidget(handler: () -> Void)
        case petition
    }
    
    //TODO: 데이터에 맞게 수정필요
    init(petitions: [String],
         searchHandler: @escaping (String) -> Void,
         buttonWidgetClickHandler: @escaping () -> Void) {
        let staticSection = [Section.static([.search(handler: searchHandler), .banner])]
        let widgetSection = [Section.widget([.widget, .buttonWidget(handler: buttonWidgetClickHandler)])]
        let petitionSection = [Section.petition(petitions.map { _ in .petition })]
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
        let cell: UICollectionViewCell
        
        switch currentSection {
        case .`static`(let items):
            switch items[indexPath.item] {
            case .search(_):
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewSearchCell.registerId, for: indexPath) as! HomeViewSearchCell
            case .banner:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewBannerCell.registerId, for: indexPath) as! HomeViewBannerCell
            case .widget:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewWidgetCell.registerId, for: indexPath) as! HomeViewWidgetCell
            case .buttonWidget(handler: _):
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewButtonWidgetCell.registerId, for: indexPath) as! HomeViewButtonWidgetCell
            default:
                cell = UICollectionViewCell()
            }
        case .petition:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewPetitionCell.registerId, for: indexPath) as! HomeViewPetitionCell
        case .widget(let items):
            switch items[indexPath.item] {
                case .widget:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewWidgetCell.registerId, for: indexPath) as! HomeViewWidgetCell
                case .buttonWidget(handler: _):
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewButtonWidgetCell.registerId, for: indexPath) as! HomeViewButtonWidgetCell
                default:
                    cell = UICollectionViewCell()
            }
        }
        return cell
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
                return CGSize(width: width, height: 75)
            }
        case .widget:
            return CGSize(width: (width/2)-5, height: 100)
        case .petition:
            return CGSize(width: width, height: 80)
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
