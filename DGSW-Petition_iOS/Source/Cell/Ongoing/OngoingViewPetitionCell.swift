//
//  OngoingViewPetitionCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/22.
//

import UIKit

class OngoingViewPetitionCell: UICollectionViewCell {
    static let registerId = "\(OngoingViewPetitionCell.self)"
    
    struct ViewModel {
        let idx: Int
        let category: String
        let title: String
        let expirationDate: Date
        let agreeCount: Int
    }
    
    //MARK: - properties
    
    var delegate: OngoingViewPetitionCellDelegate? = nil
    
    var viewModel: ViewModel! {
        didSet {
            self.categoryLable.text = viewModel.category
            self.titleLabel.text = viewModel.title
            self.expirationDateLabel.text = "~ \(viewModel.expirationDate.toString())"
            self.agreeCountLabel.text = "\(viewModel.agreeCount) 명"
        }
    }
    
    //MARK: - UI
    
    lazy var petitionStackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .vertical
    }
    
    lazy var infoStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    lazy var categoryLable = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    lazy var expirationDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .systemGray2
    }
    
    lazy var divideBar = UIView().then {
        $0.backgroundColor = .systemGray2
    }
    
    lazy var agreeCountLabel = UILabel().then {
        $0.text = "-- 명"
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .right
    }
    
    @objc
    private func didTappedView() {
        self.delegate?.onClickCell(viewModel: self.viewModel)
    }
    
    //MARK: - view lifecycle
    
    override func layoutSubviews() {
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedView)))
        
        self.contentView.addSubview(petitionStackView)
        self.contentView.addSubview(divideBar)
        
        petitionStackView.addArrangedSubview(categoryLable)
        petitionStackView.addArrangedSubview(titleLabel)
        petitionStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(expirationDateLabel)
        infoStackView.addArrangedSubview(agreeCountLabel)
        
        petitionStackView.snp.makeConstraints {
            $0.edges.equalTo(self.contentView)
        }
        
        divideBar.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(infoStackView.snp.bottom).inset(-10)
            $0.left.right.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
        }
    }
}

protocol OngoingViewPetitionCellDelegate {
    func onClickCell(viewModel: OngoingViewPetitionCell.ViewModel)
}
