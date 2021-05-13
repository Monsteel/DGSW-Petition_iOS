//
//  HomeViewWidgetCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//

import UIKit

class HomeViewWidgetCell: UICollectionViewCell {
    static let registerId = "\(HomeViewWidgetCell.self)"
    //MARK: - UI

    lazy var statusWidget = CardView().then {
        $0.cornerRadius = 15
        $0.backgroundColor = .white
        $0.borderColor = .systemGray4
        $0.borderWidth = 1
    }
    lazy var statusWidgetStackView = UIStackView().then {
        $0.axis = .vertical
    }
    lazy var agreeCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    lazy var statusCountStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    lazy var completedCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    lazy var awaitingCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var agreeCountTitleLabel = UILabel().then {
        $0.text = "누적 동의 수"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var agreeCountLabel = UILabel().then {
        $0.text = "2154 명"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
    }
    lazy var completedCountTitleLabel = UILabel().then {
        $0.text = "답변 완료"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var completedCountLabel = UILabel().then {
        $0.text = "12 건"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
    }
    lazy var awaitingCountTitleLabel = UILabel().then {
        $0.text = "답변 대기"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var awaitingCountLabel = UILabel().then {
        $0.text = "6 건"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemOrange
        $0.textAlignment = .center
    }
    
    
    // MARK: - view lifecycle
    override func layoutSubviews() {
//        self.snp.makeConstraints{
//            $0.width.equalTo(UIScreen.main.bounds.width)
//        }
        self.contentView.addSubview(statusWidget)
        statusWidgetStackView.addArrangedSubview(agreeCountStackView)
        statusWidgetStackView.addArrangedSubview(statusCountStackView)
        statusCountStackView.addArrangedSubview(completedCountStackView)
        statusCountStackView.addArrangedSubview(awaitingCountStackView)
        
        statusWidget.addSubview(statusWidgetStackView)
        
        agreeCountStackView.addArrangedSubview(agreeCountTitleLabel)
        agreeCountStackView.addArrangedSubview(agreeCountLabel)
        
        completedCountStackView.addArrangedSubview(completedCountTitleLabel)
        completedCountStackView.addArrangedSubview(completedCountLabel)
        
        awaitingCountStackView.addArrangedSubview(awaitingCountTitleLabel)
        awaitingCountStackView.addArrangedSubview(awaitingCountLabel)
        
        
        statusWidget.snp.makeConstraints {
            $0.edges.equalTo(self.contentView.safeAreaLayoutGuide)
        }
        
        statusWidgetStackView.snp.makeConstraints {
            $0.top.equalTo(statusWidget).offset(15)
            $0.bottom.equalTo(statusWidget).offset(-15)
            $0.left.equalTo(statusWidget).offset(15)
            $0.right.equalTo(statusWidget).offset(-15)
        }
        
        agreeCountStackView.snp.makeConstraints {
            $0.height.equalTo(statusWidgetStackView).multipliedBy(0.5)
        }
        
        statusCountStackView.snp.makeConstraints {
            $0.height.equalTo(statusWidgetStackView).multipliedBy(0.5)
        }
        
        completedCountStackView.snp.makeConstraints {
            $0.width.equalTo(statusCountStackView).multipliedBy(0.6)
        }
        
        awaitingCountStackView.snp.makeConstraints {
            $0.width.equalTo(statusCountStackView).multipliedBy(0.6)
        }
        
        
        
        agreeCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(agreeCountStackView).multipliedBy(0.4)
        }
        
        agreeCountLabel.snp.makeConstraints {
            $0.height.equalTo(agreeCountStackView).multipliedBy(0.6)
        }
        
        
        
        completedCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.6)
        }
        
        completedCountLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.5)
        }
        
        awaitingCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.6)
        }
        
        awaitingCountLabel.snp.makeConstraints {
            $0.height.equalTo(awaitingCountStackView).multipliedBy(0.5)
        }
    }
}
