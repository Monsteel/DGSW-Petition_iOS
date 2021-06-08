//
//  DetailPetitionViewDataSource.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewDataSource: NSObject {
    var sections: [Section]
    var delegate: DetailPetitionViewDataSourceDelegate?
    
    var agreePageCount: Int = 0
    var isShowFooter: Bool = true
    
    enum Section {
        case petition([Item])
        case agree([Item])
    }
    
    enum Item {
        case petitionStatus(_ viewModel: DetailPetitionViewStatusCell.ViewModel)
        case petitionTitle(_ viewModel: DetailPetitionViewTitleCell.ViewModel)
        case petitionAgreeCount(_ viewModel: DetailPetitionViewAgreeCountCell.ViewModel)
        case petitionInfo(_ viewModel: DetailPetitionInfoCell.ViewModel)
        case petitionProgress(_ viewModel: DetailPetitionViewProgressCell.ViewModel)
        case petitionAnswer(_ viewModel: DetailPetitionViewAnswerCell.ViewModel)
        case petitionContent(_ viewModel: DetailPetitionViewContentCell.ViewModel)
        
        case agreeInfo(_ viewModel: DetailPetitionViewAgreeInfoCell.ViewModel)
        case agreeWrite(_ viewModel: DetailPetitionViewAgreeWriteCell.ViewModel,
                        _ delegate: DetailPetitionViewAgreeWriteCellDelegate)
    }
    
    init(_ petitionViewModel: DetailPetition.Refresh.ViewModel,
         _ delegate: (DetailPetitionViewDataSourceDelegate & DetailPetitionViewAgreeWriteCellDelegate)) {
        guard let petition = petitionViewModel.petiton else {
            self.sections = []
            super.init()
            return
        }
        
        //MARK: Petition SectionItems
        var petitionSectionItems: [Item]  = [.petitionStatus(.init(isAnswer: petition.isAnswer, expirationDate: petition.expirationDate)), .petitionTitle(.init(title: petition.title)),
                                             .petitionAgreeCount(.init(count: petition.agreeCount)),
                                             .petitionInfo(.init(writerID: petition.writerID,
                                                                 category: petition.category,
                                                                 startDate: petition.createdAt,
                                                                 expirationDate: petition.expirationDate)),
                                             .petitionProgress(.init(isAnswer: petition.isAnswer, expirationDate: petition.expirationDate))]
        let answerItem: [Item] = petition.answerContent?.enumerated().map{
            .petitionAnswer(.init(content: $0.element, idx: $0.offset))
        } ?? []

        petitionSectionItems.append(contentsOf: answerItem)
        petitionSectionItems.append(.petitionContent(.init(content: petition.content)))

        let petitionSection: Section = .petition(petitionSectionItems)
        
        let agreeSection: Section = .agree([.agreeWrite(.init(), delegate)])
        
        self.sections = [petitionSection, agreeSection]
        self.delegate = delegate
        
        super.init()
    }
    
    func loadAgree(_ viewModel: DetailPetition.FetchAgree.ViewModel) {
        let newItem:[Item]? = viewModel.answers?.map({ .agreeInfo(.init(content: $0.content, writerID: $0.writerID)) })
        var existingItem:[Item]?
        
        if (newItem?.isEmpty ?? true) {
            isShowFooter = false
            return
        }
        
        agreePageCount = agreePageCount+1
        
        
        let targetIndex = sections.firstIndex {
            if case let .agree(item) = $0 {
                existingItem = item
                return true
            }
            else { return false }
        }!
        
        sections.remove(at: targetIndex)
        
        let item = existingItem! + newItem!
        
        sections.insert(.agree(item), at: targetIndex)
        
    }
}

extension DetailPetitionViewDataSource: UITableViewDataSource, UITableViewDelegate, DetailPetitionViewAgreeFooterDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        switch currentSection {
            case .petition(let items):
                return items.count
            case .agree(let items):
                return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        switch currentSection {
            case .petition(let items):
                switch items[indexPath.item] {
                    case .petitionStatus(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewStatusCell.registerId) as! DetailPetitionViewStatusCell
                        cell.viewModel = viewModel
                        return cell
                    case .petitionTitle(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewTitleCell.registerId) as! DetailPetitionViewTitleCell
                        cell.viewModel = viewModel
                        return cell
                    case .petitionAgreeCount(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewAgreeCountCell.registerId) as! DetailPetitionViewAgreeCountCell
                        cell.viewModel = viewModel
                        return cell
                    case .petitionInfo(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionInfoCell.registerId) as! DetailPetitionInfoCell
                        cell.viewModel = viewModel
                        return cell
                    case .petitionProgress(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewProgressCell.registerId) as! DetailPetitionViewProgressCell
                        cell.viewModel = viewModel
                        return cell
                    case .petitionAnswer(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewAnswerCell.registerId) as! DetailPetitionViewAnswerCell
                        cell.viewModel = viewModel
                        return cell
                    case .petitionContent(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewContentCell.registerId) as! DetailPetitionViewContentCell
                        cell.viewModel = viewModel
                        return cell
                    default: fatalError("Not Matched View")
                }
            case .agree(let items):
                switch items[indexPath.item] {
                    case .agreeInfo(let viewModel):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewAgreeInfoCell.registerId) as! DetailPetitionViewAgreeInfoCell
                        cell.viewModel = viewModel
                        return cell
                    case let .agreeWrite(viewModel, delegate):
                        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPetitionViewAgreeWriteCell.registerId) as! DetailPetitionViewAgreeWriteCell
                        cell.viewModel = viewModel
                        cell.delegate = delegate
                        return cell
                    default: fatalError("Not Matched View")
                }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(!isShowFooter){ return nil }
        
        let currentSection = sections[section]
        
        switch currentSection {
            case .petition:
                return nil
            case .agree:
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailPetitionViewAgreeFooter.registerId) as! DetailPetitionViewAgreeFooter
                view.delegate = self
                return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(!isShowFooter){ return 0 }
        
         let currentSection = sections[section]
        
        switch currentSection {
            case .petition:
                return 0
            case .agree:
                return 50
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func onClickAgreeSectionFooter() {
        delegate?.onClickloadAgreeBtn()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}

protocol DetailPetitionViewDataSourceDelegate {
    func onClickloadAgreeBtn()
    func onClickAgreeBtn(_ content: String)
}

