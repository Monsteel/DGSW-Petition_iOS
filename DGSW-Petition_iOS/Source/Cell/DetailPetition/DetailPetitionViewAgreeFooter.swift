//
//  DetailPetitionViewAgreeFooter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewAgreeFooter: UITableViewHeaderFooterView {
    static let registerId = "\(DetailPetitionViewAgreeFooter.self)"
    
    var delegate: DetailPetitionViewAgreeFooterDelegate?
    
    lazy var container = CardView().then {
        $0.cornerRadius = 5
        $0.borderColor = .systemGray
        $0.backgroundColor = .systemGray6
        $0.borderWidth = 0.5
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "동의 내용 보기 ▽"
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    override func layoutSubviews() {
        self.backgroundView = UIView(frame: self.bounds)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        self.addGestureRecognizer(tapGesture)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        self.backgroundView?.addSubview(container)
        self.container.addSubview(titleLabel)
        
        container.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    func tapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        delegate?.onClickAgreeSectionFooter()
    }
}

protocol DetailPetitionViewAgreeFooterDelegate {
    func onClickAgreeSectionFooter()
}
