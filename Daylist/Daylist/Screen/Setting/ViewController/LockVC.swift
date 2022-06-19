//
//  LockVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import RxDataSources
import SnapKit
import Then

class LockVC: BaseViewController {
    private var viewTitle = UILabel()
        .then {
            $0.text = "암호 입력"
            $0.font = UIFont.boldSystemFont(ofSize: 24)
            $0.textColor = .label
            $0.textAlignment = .center
        }
    
    private var message = UILabel()
        .then {
            $0.font = UIFont.systemFont(ofSize: 17)
            $0.textColor = .systemGray
            $0.textAlignment = .center
        }
    
    private var passwdStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 32
        }
    
    private var keypadCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let bag = DisposeBag()
    private let viewModel = LockVM()
    private var inputPasswd = ""
    private var passwdTmp = ""
    var lockType: LockType?
    private let naviBar = NavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureTitle()
        configurePasswdStackView()
        configureCollectionView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindKeypad()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindValidPW()
    }
}

// MARK: - Configure

extension LockVC {
    private func configureNaviBar() {
        naviBar.isHidden = lockType == .enter
        naviBar.configureNaviBar(targetVC: self, title: "")
        naviBar.configureBackBtn(targetVC: self, action: #selector(dismissVC), naviType: .present)
    }
    
    private func configureTitle() {
        view.addSubviews([viewTitle, message])
        message.text = lockType?.message
    }
    
    private func configurePasswdStackView() {
        view.addSubview(passwdStackView)
        for _ in 0..<4 {
            let passwdView = UIImageView(image: UIImage(named: "passwdNull"))
            passwdStackView.addArrangedSubview(passwdView)
        }
    }
    
    private func configureCollectionView() {
        let cellWidth = (screenWidth - 70) / 3
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: cellWidth , height: cellWidth / 102 * 60)
        keypadCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(keypadCV)
        keypadCV.register(KeypadCVC.self, forCellWithReuseIdentifier: KeypadCVC.className)
        keypadCV.dataSource = self
    }
    
    private func configurePWImage(with image: UIImage) {
        let passwd = self.passwdStackView.arrangedSubviews[self.inputPasswd.count] as! UIImageView
        passwd.image = image
    }
}

// MARK: - Layout

extension LockVC {
    private func configureLayout() {
        viewTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.centerX.equalToSuperview()
        }
        
        message.snp.makeConstraints {
            $0.top.equalTo(viewTitle.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        passwdStackView.snp.makeConstraints {
            $0.top.equalTo(message.snp.bottom).offset(62)
            $0.leading.equalToSuperview().offset(101)
            $0.trailing.equalToSuperview().offset(-101)
            $0.height.equalTo(20)
        }
        
        keypadCV.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(keypadCV.snp.width).multipliedBy(4.0/5.0)
            $0.bottom.equalToSuperview().offset(-66)
        }
    }
    
    private func passwdLayout(leading: CGFloat, triling: CGFloat) {
        passwdStackView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(leading)
            $0.trailing.equalToSuperview().offset(triling)
        }
        view.layoutIfNeeded()
    }
}

// MARK: - Input

extension LockVC {
    private func bindKeypad() {
        keypadCV.rx.itemSelected
            .asDriver()
            .drive(onNext: {[weak self] indexPath in
                guard let self = self,
                      let cell = self.keypadCV.cellForItem(at: indexPath) as? KeypadCVC else { return }
                switch indexPath.row {
                case 0..<9, 10:
                    self.configurePWImage(with: UIImage(named: "passwdFilled")!)
                    self.inputPasswd += cell.number.text!
                case 11:
                    self.inputPasswd.removeLast()
                    self.configurePWImage(with: UIImage(named: "passwdNull")!)
                default:
                    return
                }
                
                if self.inputPasswd.count == 4 {
                    self.checkPW()
                }
            })
            .disposed(by: bag)
    }
    
    private func checkPW() {
        switch lockType {
        case .enter:
            viewModel.input.enterPW.onNext(self.inputPasswd)
        case .changePW:
            passwdTmp = inputPasswd
            clearPW()
            lockType = .checkPW
            message.text = lockType?.message
        case .checkPW:
            viewModel.input.changePW.onNext([self.inputPasswd, self.passwdTmp])
        default:
            break
        }
    }
}

// MARK: - Output

extension LockVC {
    private func bindValidPW() {
        viewModel.output.isValidPW
            .subscribe(onNext: {[weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.dismiss(animated: true)
                } else {
                    self.wrongAnimation()
                    UIDevice.vibrate()
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods

extension LockVC {
    private func clearPW() {
        inputPasswd.removeAll()
        for i in 0..<4 {
            let passwd = passwdStackView.arrangedSubviews[i] as! UIImageView
            passwd.image = UIImage(named: "passwdNull")
        }
    }
}

// MARK: - Animation

extension LockVC {
    private func wrongAnimation() {
        self.passwdLayout(leading: 91, triling: -111)
        UIView.animate(withDuration:0.1,
                       delay: 0,
                       options: [.curveEaseInOut, .autoreverse, .repeat]) {
            self.view.isUserInteractionEnabled = false
             UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                 self.passwdLayout(leading: 111, triling: -91)
             }
        } completion: { _ in
            self.view.isUserInteractionEnabled = true
            self.message.text = self.lockType?.message
            self.passwdLayout(leading: 101, triling: -101)
            self.clearPW()
        }
        message.text = "암호가 일치하지 않습니다."
    }
}

// MARK: - DataSource

extension LockVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeypadCVC.className, for: indexPath) as? KeypadCVC else { return UICollectionViewCell() }
        
        switch indexPath.row {
        case 0..<9:
            cell.configureNumpad(with: indexPath.row + 1)
        case 10:
            cell.configureNumpad(with: 0)
        case 11:
            cell.configureBackspace()
        default:
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
}
