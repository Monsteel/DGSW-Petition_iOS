//
//  HomeViewButtonWidgetCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/12.
//

import UIKit

class HomeViewButtonWidgetCell: UICollectionViewCell {
    static let registerId = "\(HomeViewButtonWidgetCell.self)"
    
    //MARK: - properties
    
    var delegate: HomeViewButtonWidgetCellDelegate? = nil
    
    //MARK: - UI

    lazy var writePetitionBtnWidget = CardView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (didTappedButton)))
        $0.backgroundColor = .systemBlue
        $0.cornerRadius = 15
    }
    
    lazy var writePetitionBtnImage = UIImageView().then {
        $0.image = UIImage(systemName: "filemenu.and.cursorarrow")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var writePetitionBtnLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .white
        $0.text = "청원 하기"
        $0.textAlignment = .center
    }
    
    @objc
    private func didTappedButton() {
        self.delegate?.onClickWritePetitionButton()
    }
    
    // MARK: - view lifecycle
    override func layoutSubviews() {
        self.contentView.addSubview(writePetitionBtnWidget)
        
        writePetitionBtnWidget.addSubview(writePetitionBtnImage)
        writePetitionBtnWidget.addSubview(writePetitionBtnLabel)
        
        writePetitionBtnWidget.snp.makeConstraints {
            $0.edges.equalTo(self.contentView.safeAreaLayoutGuide)
        }
        
        writePetitionBtnImage.snp.makeConstraints {
            $0.top.equalTo(writePetitionBtnWidget).offset(15)
            $0.left.equalTo(writePetitionBtnWidget).offset(60)
            $0.right.equalTo(writePetitionBtnWidget).offset(-60)
            $0.bottom.equalTo(writePetitionBtnLabel.snp.top).offset(-5)
        }
        
        writePetitionBtnLabel.snp.makeConstraints {
            $0.left.equalTo(writePetitionBtnWidget)
            $0.right.equalTo(writePetitionBtnWidget)
            $0.bottom.equalTo(writePetitionBtnWidget).offset(-15)
        }
    }
}

protocol HomeViewButtonWidgetCellDelegate {
    func onClickWritePetitionButton()
}
