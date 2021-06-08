//
//  DetailPetitionViewAgreeWriteCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit

class DetailPetitionViewAgreeWriteCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewAgreeWriteCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            
        }
    }
    
    struct ViewModel {
        //Empty
    }
    
    var delegate: DetailPetitionViewAgreeWriteCellDelegate?
    
    lazy var container = CardView().then {
        $0.cornerRadius = 5
        $0.borderColor = .systemGray
        $0.backgroundColor = .systemGray6
        $0.borderWidth = 0.5
    }
    
    lazy var writeButton = UIButton().then {
        $0.setTitle("동의", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (didTappedButton)))
    }
    
    lazy var contentTextView = UITextView().then {
        $0.text = "동의합니다"
        $0.backgroundColor = .white
        $0.font = .systemFont(ofSize: 16)
    }
    
    @objc
    private func didTappedButton() {
        self.delegate?.onClickAgreeBtn(contentTextView.text)
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
        self.contentView.addSubview(container)
        self.container.addSubview(writeButton)
        self.container.addSubview(contentTextView)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        container.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(100)
        }
        
        writeButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(writeButton.snp.height)
        }
        
        contentTextView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(10)
            $0.right.equalTo(writeButton.snp.left).inset(-10)
        }
    }
}

protocol DetailPetitionViewAgreeWriteCellDelegate {
    func onClickAgreeBtn(_ content: String)
}
