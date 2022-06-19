//
//  SettingVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class SettingVC: BaseViewController {
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 8
        }
    private var darkModeBtn = UIButton()
    private var lockBtn = UIButton()
    private var versionBtn = UIButton()
    private var logoutBtn = UIButton()
    private var signoutBtn = UIButton()
    private let naviBar = NavigationBar()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureButtons()
    }
    
    override func layoutView() {
        super.layoutView()
        buttonsLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindButtonAction()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}
// MARK: - Configure

extension SettingVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "설정")
        naviBar.configureBackBtn(targetVC: self, action: #selector(dismissVC), naviType: .present)
    }
    
    private func configureButtons() {
        view.addSubview(stackView)
        let btnTitles = ["  다크모드", "  어플 잠금", "  버전 정보", "  로그아웃", "  회원 탈퇴"]
        let btnImages = ["DarkMode", "Lock", "VersionInfo", "Logout", "Signout"]
        
        for (i,btn) in [darkModeBtn, lockBtn, versionBtn, logoutBtn, signoutBtn].enumerated() {
            stackView.addArrangedSubview(btn)
            btn.setImage(UIImage(named: btnImages[i])?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.setTitle(btnTitles[i], for: .normal)
            btn.titleLabel?.font = .KyoboHandwriting(size: 15)
            btn.tintColor = .label
            btn.setTitleColor(.label, for: .normal)
            btn.contentHorizontalAlignment = .left
        }
    }
}

// MARK: - Layout

extension SettingVC {
    private func buttonsLayout() {
        [darkModeBtn, lockBtn, versionBtn, logoutBtn, signoutBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.leading.trailing.equalToSuperview()
            }
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - Input

extension SettingVC {
    private func bindButtonAction() {
        darkModeBtn.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let isDarkMode = self.overrideUserInterfaceStyle == .dark
                self.overrideUserInterfaceStyle = isDarkMode ? .light : .dark
                UserDefaults.standard.set(isDarkMode ? "Light" : "Dark", forKey: "Appearance")
                self.viewWillAppear(true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension SettingVC {
    
}
