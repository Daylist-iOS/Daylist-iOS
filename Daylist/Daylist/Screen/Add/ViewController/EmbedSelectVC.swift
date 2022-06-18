//
//  EmbedSelectVC.swift
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

class EmbedSelectVC: BaseViewController {
    private let alertBaseView = UIView()
    private let viewTitleLabel = UILabel()
        .then {
            $0.text = "URL 추가"
            $0.font = .KyoboHandwriting(size: 14)
        }
    
    private var embedBtn = UIButton()
        .then {
            $0.tintColor = .black
            $0.setImage(UIImage(systemName: "link")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
            $0.setTitle("링크 임베드", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .KyoboHandwriting(size: 12)
        }
    
    private var searchBtn = UIButton()
        .then {
            $0.tintColor = .black
            $0.setImage(UIImage(systemName: "magnifyingglass")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 33)), for: .normal)
            $0.setTitle("유튜브 영상 검색", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .KyoboHandwriting(size: 12)
        }
    
    private var stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let bag = DisposeBag()
    var addVC: AddVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
        configureAlert()
    }
    
    override func layoutView() {
        super.layoutView()
        alertLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindDismiss()
        bindButtonAction()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension EmbedSelectVC {
    private func configureContentView() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    private func configureAlert() {
        view.addSubview(alertBaseView)
        alertBaseView.backgroundColor = .white
        alertBaseView.addSubview(viewTitleLabel)
        alertBaseView.addSubview(stackView)
        stackView.addArrangedSubview(embedBtn)
        embedBtn.centerVertically()
        stackView.addArrangedSubview(searchBtn)
        searchBtn.centerVertically()
    }
}

// MARK: - Layout

extension EmbedSelectVC {
    private func alertLayout() {
        alertBaseView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        viewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(viewTitleLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
    }
}

// MARK: - Input

extension EmbedSelectVC {
    private func bindDismiss() {
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
    }
    
    private func bindButtonAction() {
        embedBtn.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false) {
                    let embedVC = EmbedVC()
                    embedVC.modalPresentationStyle = .overFullScreen
                    embedVC.addVC = self.addVC
                    self.addVC?.present(embedVC, animated: false)
                }
            })
            .disposed(by: bag)
        
        searchBtn.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false) {
                    let searchVC = YoutubeSearchVC()
                    searchVC.addVC = self.addVC
                    self.addVC?.navigationController?.pushViewController(searchVC, animated: true)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension EmbedSelectVC {
    
}
