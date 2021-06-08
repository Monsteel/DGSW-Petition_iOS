//
//  DetailPetitionViewTitleCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewTitleCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewTitleCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            self.titleLabel.text = viewModel.title
        }
    }
    
    struct ViewModel {
        let title: String
    }
    
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 24)
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
        self.addSubview(titleLabel)
        self.translatesAutoresizingMaskIntoConstraints = true
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
}
