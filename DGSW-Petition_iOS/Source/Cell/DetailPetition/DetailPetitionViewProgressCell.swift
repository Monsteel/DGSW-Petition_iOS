//
//  DetailPetitionViewProgressCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/02.
//

import UIKit
import FlexibleSteppedProgressBar

class DetailPetitionViewProgressCell: UITableViewCell {
    static let registerId = "\(DetailPetitionViewProgressCell.self)"
    
    var viewModel: ViewModel! {
        didSet {
            if(viewModel.isAnswer){
                progressBar.currentIndex = 3
            } else if(viewModel.expirationDate.before(Date())){
                progressBar.currentIndex = 2
            } else {
                progressBar.currentIndex = 1
            }
            
        }
    }
    
    struct ViewModel {
        let isAnswer: Bool
        let expirationDate: Date
    }
    
    lazy var progressBar: FlexibleSteppedProgressBar = FlexibleSteppedProgressBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.numberOfPoints = 4
        $0.radius = 8
        $0.lineHeight = 3
        $0.progressRadius = 6
        
        $0.delegate = self
        
        $0.stepTextFont = .systemFont(ofSize: 14)
        $0.stepTextColor = .black
        
        $0.currentSelectedTextColor = .systemBlue
        $0.currentSelectedCenterColor = .systemBlue
        $0.selectedBackgoundColor = .systemBlue
        $0.stepTextColor = .black
    }
    
    lazy var container: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(container)
        container.addSubview(progressBar)
        
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().inset(40)
            $0.left.equalToSuperview().inset(40)
        }
    }
}

extension DetailPetitionViewProgressCell: FlexibleSteppedProgressBarDelegate {
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            switch index {
                case 0: return "청원 시작"
                case 1: return "청원진행중"
                case 2: return "청원종료"
                case 3: return "답변완료"
                default: return ""
            }
        }
        return ""
    }
}
