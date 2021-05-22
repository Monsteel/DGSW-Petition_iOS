//
//  HomeViewEmptyPetitionCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/20.
//

import UIKit

class HomeViewEmptyPetitionCell: UICollectionViewCell {
    static let registerId = "\(HomeViewEmptyPetitionCell.self)"
    
    struct ViewModel {
        let type: Type
        let errorMessage: String
    }
    
    enum `Type` {
        case loading
        case justEmpty
        case failedLoad
    }
    
    //MARK: - properties
    
    var delegate: HomeViewEmptyPetitionCellDelegate? = nil
    
    var viewModel: ViewModel!{
        didSet {
            switch viewModel.type {
                case .loading:
                    setLoadingView()
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
    lazy var button = UIButton().then {
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.backgroundColor = .none
        $0.layer.cornerRadius = 5.0
        $0.layer.borderWidth = 0.5
        $0.setTitleColor(.systemGray, for: .normal)
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(onTapRefreshButton), for: .touchUpInside)
    }
    
    @objc
    private func onTapRefreshButton(){
        self.delegate?.onClickRefreshButton()
    }
    
    @objc
    private func onTapWritePetitionButton(){
        self.delegate?.onClickWritePetitionButton()
    }
    
    
    //MARK: - view lifecycle
    
    override func layoutSubviews() {
        self.contentView.addSubview(view)
        
        self.view.addSubview(self.errorImageView)
        self.view.addSubview(self.errorMessageLabel)
        self.view.addSubview(self.button)
        
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
            $0.bottom.equalTo(button.snp.top).inset(-15)
            $0.left.right.equalTo(self.view)
        }
        
        self.button.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.bottom.equalTo(self.view)
            $0.width.equalTo(self.errorImageView).offset(-200)
            $0.height.equalTo(30)
        }

    }
    
    private func setLoadingView(){
        //TODO: -로딩뷰
    }
    
    private func setJustEmptyView() {
        errorImageView.image = UIImage(systemName: "chevron.left.slash.chevron.right")
        button.setTitle("청원 작성하기", for: .normal)
        errorMessageLabel.text = viewModel.errorMessage
    }
    
    private func setFailledLoad(){
        errorImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        button.setTitle("재시도", for: .normal)
        errorMessageLabel.text = viewModel.errorMessage
    }
}

protocol HomeViewEmptyPetitionCellDelegate {
    func onClickRefreshButton()
    func onClickWritePetitionButton()
}

