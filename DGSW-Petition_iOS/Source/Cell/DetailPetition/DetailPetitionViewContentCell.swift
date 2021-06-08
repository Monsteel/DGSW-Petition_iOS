//
//  DetailPetitionViewContentCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewContentCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewContentCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            self.contentLabel.text = viewModel.content
        }
    }
    
    struct ViewModel {
        let content: String
    }
    
    
    lazy var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.text = "청원 내용"
    }
    
    lazy var titleDivider = UIView().then {
        $0.backgroundColor = .systemGray4
    }
    
    lazy var contentLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = .max
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(contentLabel)
        self.addSubview(titleLabel)
        self.addSubview(titleDivider)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
        }
        
        titleDivider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-5)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleDivider.snp.bottom).inset(-10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
}
