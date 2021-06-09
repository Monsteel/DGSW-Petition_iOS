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
    
    let tabbarItems = ["홈", "진행중", "답변대기", "답변완료"]
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
        
        let editButton   = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(didTapLogoutButton))
        editButton.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc
    func didTapLogoutButton() {
        let alertController = UIAlertController(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        
        alertController.addAction(.init(title: "로그아웃", style: .destructive) { _ in
            KeychainManager.shared.logout()
            
            let destinationVC = WelcomeViewController().then {
                $0.modalPresentationStyle = .fullScreen
            }
            self.present(destinationVC, animated: false)
        })
        alertController.addAction(.init(title: "취소", style: .cancel) { _ in })
        
        
        self.present(alertController, animated: true, completion: nil)
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

