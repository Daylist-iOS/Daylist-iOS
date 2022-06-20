//
//  DetailVC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class DetailVC: BaseViewController {
    
    // MARK: Properties
    private var naviBar = NavigationBar()
    private var detailSV = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private var cdPlayerView = CDPlayerView()
    private var titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private var titleLabel = UILabel().then {
        $0.font = UIFont.KyoboHandwriting(size: 20.0)
        $0.textColor = .black
        $0.text = "오늘의 플레이리스트"
    }
    
    private var emotionImageView = UIImageView().then {
        $0.image = EmotionType(rawValue: 0)?.emotionImage
    }
    
    private var descriptionTextView = UITextView().then {
        $0.font = UIFont.KyoboHandwriting(size: 15.0)
        $0.textColor = .lightDarkGray
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    
    // MARK: Variables
    private var bag = DisposeBag()
    private var viewModel = DetailVM()
    var summaryData: CalendarSummaryModel?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionalBindData()
    }
    
    // MARK: Configure
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureCDPlayerView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureUI()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindLoading()
        bindOnError()
    }
}

// MARK: - Configure

extension DetailVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "ㅇㅇㅇ")
        naviBar.configureBackBtn(targetVC: self, action: #selector(popVC), naviType: .push)
        naviBar.configureRightBarBtn(targetVC: self, image: UIImage(named: "btn_more") ?? UIImage())
    }
    
    private func configureCDPlayerView() {
        cdPlayerView.configureLayout(with: .detail)
        cdPlayerView.configurePlayerBtn(playerType: .detail, target: self, action: #selector(goToMediaLink))
    }
    
    private func optionalBindData() {
        if let summary = summaryData {
            print(summary)
        }
    }
    
    @objc
    private func goToMediaLink() {
        print("goToMediaLink")
    }
}

// MARK: - Layout

extension DetailVC {
    private func configureUI() {
        view.addSubview(detailSV)
        detailSV.addSubview(contentView)
        contentView.addSubviews([cdPlayerView, titleStackView, descriptionTextView])
        titleStackView.addArrangedSubview(emotionImageView)
        titleStackView.addArrangedSubview(titleLabel)
        
        detailSV.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.width.centerX.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        cdPlayerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 287))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 287) * 260 / 287)
            $0.centerX.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.top.equalTo(cdPlayerView.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 32))
        }

        emotionImageView.snp.makeConstraints {
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 32))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 32) * 33 / 32)
        }

        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Output

extension DetailVC {
    private func bindLoading() {
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                self.loading(loading: loading)
            })
            .disposed(by: bag)
    }
    
    private func bindOnError() {
        viewModel.output.onError
            .asDriver(onErrorJustReturn: .unknown)
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.description)
            })
            .disposed(by: bag)
    }
}
