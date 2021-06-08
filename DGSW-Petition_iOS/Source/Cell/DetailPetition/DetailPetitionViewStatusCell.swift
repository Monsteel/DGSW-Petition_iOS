//
//  DetailPetitionViewStatusCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewStatusCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewStatusCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            if(viewModel.isAnswer){
                self.statusLabel.text = "- 답변 완료 -"
            } else if(viewModel.expirationDate.before(Date())){
                self.statusLabel.text = "- 청원 종료 -"
            } else {
                self.statusLabel.text = "- 청원 진행중 -"
            }
        }
    }
    
    struct ViewModel {
        let isAnswer: Bool
        let expirationDate: Date
    }
    
    lazy var statusLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    func configure() {
        self.addSubview(statusLabel)
        self.translatesAutoresizingMaskIntoConstraints = true
        
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
}
