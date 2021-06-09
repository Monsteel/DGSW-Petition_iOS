//
//  HomeViewWidgetCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//

import UIKit

class HomeViewWidgetCell: UICollectionViewCell {
    static let registerId = "\(HomeViewWidgetCell.self)"
    
    struct ViewModel {
        let agreeCount: Int
        let completedCount: Int
        let awaitingCount: Int
    }
    
    //MARK: - properties
    
    var delegate: HomeViewWidgetCellDelegate? = nil
    
    var viewModel: ViewModel! {
        didSet {
            if(viewModel == nil) { return }
            self.errorView.isHidden = true
            self.loadingView.isHidden = true
            self.statusWidget.isHidden = false
            self.agreeCountLabel.text = "\(viewModel.agreeCount) 명"
            self.completedCountLabel.text = "\(viewModel.completedCount) 건"
            self.awaitingCountLabel.text = "\(viewModel.awaitingCount) 건"
        }
    }
    
    var errorMessage: String? {
        didSet {
            if(viewModel != nil || isLoading) { return }
            errorMessageLabel.text = "오류가 발생했습니다."
            errorViewConstraintSettings()
        }
    }
    
    var isLoading: Bool! {
        didSet {
            if(isLoading == nil) { return }
            if(isLoading){
                setLoadingView()
            }
        }
    }
    
    //MARK: - UI
    
    lazy var loadingView = CardView().then {
        $0.cornerRadius = 15
        $0.backgroundColor = .white
        $0.borderColor = .systemGray4
        $0.borderWidth = 1
    }
    
    lazy var indicator = UIActivityIndicatorView()
    
    lazy var statusWidget = CardView().then {
        $0.cornerRadius = 15
        $0.backgroundColor = .white
        $0.borderColor = .systemGray4
        $0.borderWidth = 1
    }
    lazy var statusWidgetStackView = UIStackView().then {
        $0.axis = .vertical
    }
    lazy var agreeCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    lazy var statusCountStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    lazy var completedCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    lazy var awaitingCountStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var agreeCountTitleLabel = UILabel().then {
        $0.text = "누적 동의 수"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var agreeCountLabel = UILabel().then {
        $0.text = "-- 명"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
    }
    lazy var completedCountTitleLabel = UILabel().then {
        $0.text = "답변 완료"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var completedCountLabel = UILabel().then {
        $0.text = "- 건"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemBlue
        $0.textAlignment = .center
    }
    lazy var awaitingCountTitleLabel = UILabel().then {
        $0.text = "답변 대기"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var awaitingCountLabel = UILabel().then {
        $0.text = "- 건"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .systemOrange
        $0.textAlignment = .center
    }
    
    private var errorView = CardView().then {
        $0.backgroundColor = .white
        $0.alpha = 0.5
        
        $0.cornerRadius = 15
        $0.backgroundColor = .white
        $0.borderColor = .systemGray4
        $0.borderWidth = 1
    }
    lazy var errorMessageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    lazy var button = UIButton().then {
        $0.setTitle("재시도", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.backgroundColor = .none
        $0.layer.cornerRadius = 5.0
        $0.layer.borderWidth = 0.5
        $0.setTitleColor(.systemGray, for: .normal)
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(onTapRefreshButton), for: .touchUpInside)
    }
    
    private func errorViewConstraintSettings() {
        self.errorView.isHidden = false
        self.statusWidget.isHidden = true
        self.loadingView.isHidden = true
        
        self.contentView.addSubview(errorView)
        self.contentView.addSubview(errorMessageLabel)
        self.contentView.addSubview(button)

        self.contentView.bringSubviewToFront(errorView)
        self.contentView.bringSubviewToFront(errorMessageLabel)
        self.contentView.bringSubviewToFront(button)
        
        errorView.snp.makeConstraints {
            $0.edges.equalTo(self.contentView)
        }
        
        self.errorMessageLabel.snp.makeConstraints {
            $0.centerY.equalTo(errorView).offset(-15)
            $0.top.equalTo(self.errorView).inset(20)
            $0.left.equalTo(self.errorView)
            $0.right.equalTo(self.errorView)
        }
        
        self.button.snp.makeConstraints {
            $0.centerX.equalTo(self.errorMessageLabel)
            $0.centerY.equalTo(errorView).offset(15)
            $0.width.equalTo(self.errorMessageLabel).inset(20)
            $0.height.equalTo(25)
        }
    }
    
    private func setLoadingView() {
        errorView.isHidden = true
        statusWidget.isHidden = true
        
        contentView.addSubview(loadingView)
        contentView.addSubview(indicator)
        
        indicator.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(50)
            $0.center.equalTo(contentView.center)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalTo(self.contentView)
        }
        
        indicator.startAnimating()
    }
    
    @objc
    private func onTapRefreshButton(){
        self.delegate?.onClickRefreshButton()
    }
    
    
    // MARK: - view lifecycle
    override func layoutSubviews() {
        self.contentView.addSubview(statusWidget)
        statusWidgetStackView.addArrangedSubview(agreeCountStackView)
        statusWidgetStackView.addArrangedSubview(statusCountStackView)
        statusCountStackView.addArrangedSubview(completedCountStackView)
        statusCountStackView.addArrangedSubview(awaitingCountStackView)
        
        statusWidget.addSubview(statusWidgetStackView)
        
        agreeCountStackView.addArrangedSubview(agreeCountTitleLabel)
        agreeCountStackView.addArrangedSubview(agreeCountLabel)
        
        completedCountStackView.addArrangedSubview(completedCountTitleLabel)
        completedCountStackView.addArrangedSubview(completedCountLabel)
        
        awaitingCountStackView.addArrangedSubview(awaitingCountTitleLabel)
        awaitingCountStackView.addArrangedSubview(awaitingCountLabel)
        
        
        statusWidget.snp.makeConstraints {
            $0.edges.equalTo(self.contentView.safeAreaLayoutGuide)
        }
        
        statusWidgetStackView.snp.makeConstraints {
            $0.top.equalTo(statusWidget).offset(15)
            $0.bottom.equalTo(statusWidget).offset(-15)
            $0.left.equalTo(statusWidget).offset(15)
            $0.right.equalTo(statusWidget).offset(-15)
        }
        
        agreeCountStackView.snp.makeConstraints {
            $0.height.equalTo(statusWidgetStackView).multipliedBy(0.5)
        }
        
        statusCountStackView.snp.makeConstraints {
            $0.height.equalTo(statusWidgetStackView).multipliedBy(0.5)
        }
        
        completedCountStackView.snp.makeConstraints {
            $0.width.equalTo(statusCountStackView).multipliedBy(0.6)
        }
        
        awaitingCountStackView.snp.makeConstraints {
            $0.width.equalTo(statusCountStackView).multipliedBy(0.6)
        }
        
        
        
        agreeCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(agreeCountStackView).multipliedBy(0.4)
        }
        
        agreeCountLabel.snp.makeConstraints {
            $0.height.equalTo(agreeCountStackView).multipliedBy(0.6)
        }
        
        
        
        completedCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.6)
        }
        
        completedCountLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.5)
        }
        
        awaitingCountTitleLabel.snp.makeConstraints {
            $0.height.equalTo(completedCountStackView).multipliedBy(0.6)
        }
        
        awaitingCountLabel.snp.makeConstraints {
            $0.height.equalTo(awaitingCountStackView).multipliedBy(0.5)
        }
    }
}


protocol HomeViewWidgetCellDelegate {
    func onClickRefreshButton()
}
