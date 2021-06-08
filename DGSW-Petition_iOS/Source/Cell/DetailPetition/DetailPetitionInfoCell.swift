//
//  DetailPetitionInfoCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionInfoCell: UITableViewCell {
    static let registerId = "\(DetailPetitionInfoCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            
            let category = NSMutableAttributedString()
                .bold(string: "카테고리 ", fontSize: 14)
                .regular(string: "\(viewModel.category) ", fontSize: 14)
            
            let startDate = NSMutableAttributedString()
                .bold(string: "청원시작 ", fontSize: 14)
                .regular(string: "\(viewModel.startDate.toString()) ", fontSize: 14)
            
            let expirationDate = NSMutableAttributedString()
                .bold(string: "청원마감 ", fontSize: 14)
                .regular(string: "\(viewModel.expirationDate.toString()) ", fontSize: 14)

            let writerIDendIdx: String.Index = viewModel.writerID.index(viewModel.writerID.startIndex, offsetBy: 3)
            
            let writerID = NSMutableAttributedString()
                .bold(string: "청원인 ", fontSize: 14)
                .regular(string: "\(String(viewModel.writerID[...writerIDendIdx]))***", fontSize: 14)
            
            
            
            self.categoryLabel.attributedText = category
            self.startDateLabel.attributedText = startDate
            self.expirationDateLabel.attributedText = expirationDate
            self.writerIDLabel.attributedText = writerID
        }
    }
    
    struct ViewModel {
        let writerID: String
        let category: String
        let startDate: Date
        let expirationDate: Date
    }
    
    lazy var infoContainer = CardView().then {
        $0.cornerRadius = 5
        $0.borderColor = .systemGray
        $0.backgroundColor = .systemGray6
        $0.borderWidth = 0.5
    }
    
    
    lazy var verticalFirstStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    lazy var verticalSecondStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    lazy var horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    
    lazy var categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var startDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var expirationDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var writerIDLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(infoContainer)
        
        self.infoContainer.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalFirstStackView)
        horizontalStackView.addArrangedSubview(verticalSecondStackView)
        
        verticalFirstStackView.addArrangedSubview(categoryLabel)
        verticalFirstStackView.addArrangedSubview(writerIDLabel)
        
        verticalSecondStackView.addArrangedSubview(startDateLabel)
        verticalSecondStackView.addArrangedSubview(expirationDateLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = true
                
        infoContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(20)

        }
    }
}
