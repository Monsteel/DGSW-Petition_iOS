//
//  HomeViewBannerCell.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/10.
//

import UIKit

class HomeViewBannerCell: UICollectionViewCell {
    static let registerId = "\(HomeViewBannerCell.self)"
    
    //MARK: - UI
    lazy var bannerBox = CardView().then {
        $0.borderWidth = 1
        $0.borderColor = .systemGray4
        $0.clipsToBounds = true
    }
    lazy var bannerImageView = UIImageView().then {
        $0.image = UIImage(named: "petition_background_img")
        $0.contentMode = .scaleAspectFill
    }

    func imageBoxConstraintSettings() {
        self.bannerBox.addSubview(bannerImageView)
        self.contentView.addSubview(bannerBox)
    
        bannerBox.snp.makeConstraints {
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
            $0.width.equalTo(contentView.safeAreaLayoutGuide)
            $0.left.equalTo(contentView.safeAreaLayoutGuide)
            $0.top.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        bannerImageView.snp.makeConstraints {
            $0.edges.equalTo(bannerBox)
        }
    }
    
    // MARK: - view lifecycle
    override func layoutSubviews() {
        imageBoxConstraintSettings()
    }
}
