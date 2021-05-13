//
//  HomeViewPetitionCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//

import UIKit

class HomeViewPetitionCell: UICollectionViewCell {
    static let registerId = "\(HomeViewPetitionCell.self)"
    
    lazy var petitionStackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .vertical
    }
    
    lazy var infoStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    lazy var categoryLable = UILabel().then {
        $0.text = "정치/외교"
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "전용길 사감선생님의 사임을 검토해 주세요"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    lazy var expirationDateLabel = UILabel().then {
        $0.text = "~ 2021-05-19"
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .systemGray2
    }
    
    lazy var divideBar = UIView().then {
        $0.backgroundColor = .systemGray2
    }
    
    lazy var agreeCountLabel = UILabel().then {
        $0.text = "287,872명"
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .right
    }
    
    override func layoutSubviews() {
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
