//
//  EmbedVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/18.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class EmbedVC: BaseViewController {
    private let baseView = UIView()
        .then {
            $0.backgroundColor = .white
        }
    
    private var searchTextField = UITextField()
        .then {
            $0.placeholder = "URL"
            $0.font = .KyoboHandwriting(size: 15)
            $0.clearButtonMode = .always
        }
    
    private let separator = UIView()
        .then {
            $0.backgroundColor = .lightGray
        }
    
    private let messageLabel = UILabel()
        .then {
            $0.text = "해당 링크의 정보를 불러올 수 없습니다.\n링크를 다시 확인해주세요."
            $0.font = .KyoboHandwriting(size: 12)
            $0.textAlignment = .center
            $0.textColor = .darkGray
            $0.setLineBreakMode()
        }
    
    private var stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private var cancelBtn = UIButton()
        .then {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .KyoboHandwriting(size: 12)
            $0.backgroundColor = .lightGray
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
        }
    
    private var confirmBtn = UIButton()
        .then {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .KyoboHandwriting(size: 12)
            $0.backgroundColor = .lightGray
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
        }
    
    private let resultView = YoutubeSearchTVC()
        .then {
            $0.isHidden = true
        }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
        configureEmbedView()
    }
    
    override func layoutView() {
        super.layoutView()
        embedViewLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindButtonAction()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindResultView()
    }
    
}

// MARK: - Configure

extension EmbedVC {
    private func configureContentView() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    private func configureEmbedView() {
        view.addSubview(baseView)
        baseView.addSubview(searchTextField)
        baseView.addSubview(separator)
        baseView.addSubview(messageLabel)
        baseView.addSubview(stackView)
        stackView.addArrangedSubview(cancelBtn)
        stackView.addArrangedSubview(confirmBtn)
        baseView.addSubview(resultView)
    }
}

// MARK: - Layout

extension EmbedVC {
    private func embedViewLayout() {
        baseView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(separator.snp.bottom).offset(28)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom)
            $0.bottom.equalTo(stackView.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Input

extension EmbedVC {
    private func bindButtonAction() {
        cancelBtn.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
        
        confirmBtn.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension EmbedVC {
    
}
