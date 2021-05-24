//
//  HomeViewPetitionHeader.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//

import UIKit

class HomeViewPetitionHeader: UICollectionReusableView {
    static let registerId = "\(HomeViewPetitionHeader.self)"
    
    lazy var titleLabel = UILabel().then {
        $0.text = "전체 추천순 TOP 10"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var divideBar = UIView().then {
        $0.backgroundColor = .black
    }
    
    override func layoutSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(divideBar)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(self).inset(10)
        }
        
        divideBar.snp.makeConstraints {
            $0.left.right.equalTo(self).inset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.height.equalTo(1)
        }
    }

}
