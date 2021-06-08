//
//  DetailPetitionViewAgreeInfoCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewAgreeInfoCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewAgreeInfoCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            let writerIDendIdx: String.Index = viewModel.writerID.index(viewModel.writerID.startIndex, offsetBy: 3)
            
            self.writterLabel.text = "\(String(viewModel.writerID[...writerIDendIdx]))***"
            self.contentLabel.text = viewModel.content
        }
    }
    
    struct ViewModel {
        let content: String
        let writerID: String
    }
    
    
    lazy var writterLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .left
    }
    
    lazy var titleDivider = UIView().then {
        $0.backgroundColor = .systemGray4
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = true
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(writterLabel)
        self.addSubview(contentLabel)
        self.addSubview(titleDivider)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        writterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(writterLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(titleDivider.snp.top)
        }
        
        titleDivider.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
