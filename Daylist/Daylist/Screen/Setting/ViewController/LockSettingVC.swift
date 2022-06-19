//
//  LockSettingVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class LockSettingVC: BaseViewController {
    let naviBar = NavigationBar()
    let bag = DisposeBag()
    private var lockView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    private var lockTitle = UILabel()
        .then {
            $0.text = "화면 잠금"
            $0.textColor = .label
            $0.font = .KyoboHandwriting(size: 15)
        }
    private var lockSwitch = UISwitch()
        .then {
            $0.onTintColor = .label
            $0.isOn = UserDefaults.standard.string(forKey: UserDefaults.Keys.lockPasswd) != nil
        }
    
    private let hideView = UIView()
    private var changePasswdBtn = UIButton()
        .then {
            $0.setTitle("암호 변경", for: .normal)
            $0.setTitleColor(.label, for: .normal)
            $0.titleLabel?.font = .KyoboHandwriting(size: 15)
            $0.contentHorizontalAlignment = .left
        }
    
    private var warningMessage = UILabel()
        .then {
            $0.text = "⚠ 비밀번호 분실 시 앱을 삭제하고 재설치 해야하며 저장된 미디어는 모두 삭제됩니다."
            $0.font = .KyoboHandwriting(size: 12)
            $0.textColor = .red
            $0.setLineBreakMode()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLockSwitch()
        hideViewLayout(isHidden: !lockSwitch.isOn)
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
        configureLockSwitch()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
        hideViewLayout(isHidden: !lockSwitch.isOn)
    }
    
    override func bindInput() {
        super.bindInput()
        bindSwitch()
        bindButtonAction()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension LockSettingVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "화면 잠금")
        naviBar.configureBackBtn(targetVC: self, action: #selector(popVC), naviType: .push)
    }
    
    private func configureContentView() {
        view.addSubview(hideView)
        view.addSubview(lockView)
        lockView.addSubview(lockTitle)
        lockView.addSubview(lockSwitch)
        view.addSubview(warningMessage)
        hideView.addSubview(changePasswdBtn)
    }
    
    private func configureLockSwitch() {
        lockSwitch.isOn = UserDefaults.standard.string(forKey: UserDefaults.Keys.lockPasswd) != nil
    }
}

// MARK: - Layout

extension LockSettingVC {
    private func configureLayout() {
        lockView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        lockTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        lockSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func hideViewLayout(isHidden: Bool) {
        hideView.snp.remakeConstraints {
            $0.top.equalTo(isHidden ? naviBar.snp.bottom : lockView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        changePasswdBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        warningMessage.snp.makeConstraints {
            $0.top.equalTo(hideView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - Input

extension LockSettingVC {
    private func bindSwitch() {
        lockSwitch.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showLockVC()
            })
            .disposed(by: bag)
        
        lockView.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.lockSwitch.setOn(!self.lockSwitch.isOn, animated: true)
                self.showLockVC()
            })
            .disposed(by: bag)
    }
    
    private func bindButtonAction() {
        changePasswdBtn.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let changePW = LockVC()
                changePW.lockType = .changePW
                changePW.modalPresentationStyle = .overFullScreen
                self.present(changePW, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension LockSettingVC {
    
}

// MARK: - Custom Methods
extension LockSettingVC {
    private func showLockVC() {
        UIView.animate(withDuration: 0.2) {
            self.hideViewLayout(isHidden: !self.lockSwitch.isOn)
            self.view.layoutIfNeeded()
        }
        
        if lockSwitch.isOn {
            let lockVC = LockVC()
            lockVC.lockType = .changePW
            lockVC.modalPresentationStyle = .fullScreen
            present(lockVC, animated: true)
        } else {
            UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.lockPasswd)
        }
    }
}
