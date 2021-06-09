//
//  HomeViewSearchCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//

import UIKit

class HomeViewSearchCell: UICollectionViewCell {
    static let registerId = "\(HomeViewSearchCell.self)"
    
    // MARK: - properties
    
    var delegate: HomeViewSearchCellDelegate? = nil
    
    // MARK: - UI
    lazy var searchView = CardView().then {
        $0.cornerRadius = 10
        $0.borderWidth = 1.5
        $0.borderColor = .systemBlue
        $0.backgroundColor = .white
    }
    lazy var searchTextField = UITextField().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.font = .systemFont(ofSize: 16)
    }
    lazy var searchButton = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .systemBlue
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (didTappedSearchButton)))
    }
    
    @objc
    private func didTappedSearchButton() {
        self.delegate?.search(searchTextField.text ?? "")
    }
        
    // MARK: - view lifecycle
    override func layoutSubviews() {
        self.searchView.addSubview(searchTextField)
        self.searchView.addSubview(searchButton)
        self.contentView.addSubview(searchView)

        searchView.snp.makeConstraints {
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
            $0.width.equalTo(contentView.safeAreaLayoutGuide)
            $0.left.equalTo(contentView.safeAreaLayoutGuide)
            $0.top.equalTo(contentView.safeAreaLayoutGuide)
        }

        searchTextField.snp.makeConstraints {
            $0.left.equalTo(searchView).offset(10)
            $0.top.equalTo(searchView)
            $0.bottom.equalTo(searchView)
        }

        searchButton.snp.makeConstraints {
            $0.right.equalTo(searchView).offset(-15)
            $0.top.equalTo(searchView)
            $0.bottom.equalTo(searchView)
            $0.left.equalTo(searchTextField.snp.right)
            $0.width.equalTo(20)
        }
    }
}

protocol HomeViewSearchCellDelegate {
    func search(_ keyword: String)
}
