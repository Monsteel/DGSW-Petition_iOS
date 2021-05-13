//
//  MainViewController.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/27.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

class MainViewController: Tabman.TabmanViewController {
    
    let tabbarItems = ["홈", "진행중", "대기중", "답변완료"]
    let pagerControllers = [HomeViewController(),OngoingViewController(),
                            AwaitingViewController(),CompletedViewController()]
    
    // MARK: - UI
    
    lazy var titleView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "학생 청원 게시판"
        $0.font = .boldSystemFont(ofSize: 16.0)
    }
    
    lazy var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "dgsw_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var tabbar = TMBar.ButtonBar().then {
        $0.layout.transitionStyle = .snap
        $0.layout.contentMode = .fit
        $0.backgroundView.style = .clear
        $0.backgroundColor = .white
        
        $0.buttons.customize { btn in
            btn.tintColor = .black
            btn.selectedTintColor = .systemBlue
            btn.font = .systemFont(ofSize: 16)
        }
        
        $0.indicator.overscrollBehavior = .compress
        $0.indicator.tintColor = .systemBlue
        $0.indicator.weight = .light
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.titleView)
        view.addSubview(self.titleLabel)
        view.addSubview(self.titleImageView)
        
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor  = .white //Navigationbar background color 설정
        navigationController?.navigationBar.isTranslucent = false //불투명 설정
        
        navigationItem.titleView = titleView
        
        titleImageView.snp.makeConstraints {
            $0.height.equalTo(titleView.snp.height)
            $0.width.equalTo(80)
        }
        
        titleView.addArrangedSubview(titleImageView)
        titleView.addArrangedSubview(titleLabel)
        
        self.dataSource = self
        addBar(tabbar, dataSource: self, at: .top)
    }
}

extension MainViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return pagerControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIKit.UIViewController? {
        return pagerControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: tabbarItems[index])
    }
}

