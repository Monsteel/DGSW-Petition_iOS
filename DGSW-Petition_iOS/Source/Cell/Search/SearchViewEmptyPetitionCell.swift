//
//  SearchViewEmptyPetitionCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

class SearchViewEmptyPetitionCell: UICollectionViewCell {
    static let registerId = "\(SearchViewEmptyPetitionCell.self)"
    
    struct ViewModel {
        let type: Type
        let errorMessage: String
    }
    
    enum `Type` {
        case justEmpty
        case failedLoad
    }
    
    //MARK: - properties
    
    var viewModel: ViewModel!{
        didSet {
            switch viewModel.type {
                case .justEmpty:
                    setJustEmptyView()
                case .failedLoad:
                    setFailledLoad()
            }
        }
    }
    
    //MARK: - UI
    
    lazy var view = UIView()
    lazy var errorImageView = UIImageView().then {
        $0.tintColor = .systemGray4
        $0.image = UIImage(systemName: "chevron.left.slash.chevron.right")
        $0.contentMode = .scaleAspectFit
    }
    lazy var errorMessageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    //MARK: - view lifecycle
    
    override func layoutSubviews() {
        self.contentView.addSubview(view)
        
        self.view.addSubview(self.errorImageView)
        self.view.addSubview(self.errorMessageLabel)
        
        self.view.snp.makeConstraints {
            $0.center.equalTo(self.contentView.snp.center)
            $0.height.equalTo(200)
            $0.width.equalTo(self.contentView.safeAreaLayoutGuide)
        }
        
        self.errorImageView.snp.makeConstraints {
            $0.top.equalTo(self.view)
            $0.left.right.equalTo(self.view)
        }
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(errorImageView.snp.bottom).offset(15)
            $0.bottom.equalTo(self.view)
            $0.left.right.equalTo(self.view)
        }
    }
    
    private func setJustEmptyView() {
        errorImageView.image = UIImage(systemName: "chevron.left.slash.chevron.right")
        errorMessageLabel.text = viewModel.errorMessage
    }
    
    private func setFailledLoad(){
        errorImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        errorMessageLabel.text = viewModel.errorMessage
    }
}

