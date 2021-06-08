//
//  DetailPetitionViewAgreeCountCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewAgreeCountCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewAgreeCountCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            self.countLabel.text = "참여 인원 : [\(viewModel.count.toDecimalString())명]"
        }
    }
    
    struct ViewModel {
        let count: Int
    }
    
    
    lazy var countLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(countLabel)
        self.translatesAutoresizingMaskIntoConstraints = true
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
