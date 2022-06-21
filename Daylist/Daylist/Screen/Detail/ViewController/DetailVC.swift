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
import Kingfisher

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
    var playlistId: Int?
    
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
        bindDetailData()
    }
}

// MARK: - Configure

extension DetailVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "")
        naviBar.configureBackBtn(targetVC: self, action: #selector(popVC), naviType: .push)
        naviBar.configureRightBarBtn(targetVC: self, image: UIImage(named: "btn_more") ?? UIImage())
    }
    
    private func configureCDPlayerView() {
        cdPlayerView.configureLayout(with: .detail)
        cdPlayerView.configurePlayerBtn(playerType: .detail, target: self, action: #selector(goToMediaLink))
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
    
    private func bindDetailData() {
        viewModel.output.detailData
            .subscribe(onNext: { [weak self] data in
                self?.naviBar.setNaviBarTitleText(title: data.createdAt.serverTimeToString(dateFormat: "yyyy.MM.dd"))
                guard let thumbnailURL = URL(string: data.thumbnailImage) else { return }
                KingfisherManager.shared.retrieveImage(with: thumbnailURL) { image in
                    switch image {
                    case .success(let imageData):
                        self?.cdPlayerView.setThumbnailImage(with: imageData.image)
                    case .failure:
                        return
                    }
                }

                self?.titleLabel.text = data.title
                self?.emotionImageView.image = EmotionType(rawValue: data.emotion)?.emotionImage
                self?.descriptionTextView.text = data.description
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods

extension DetailVC {
    private func optionalBindData() {
        if let id = playlistId {
            viewModel.getDetailData(with: DetailRequestModel(userId: 1, playlistId: id))
        }
    }
    
    @objc
    private func goToMediaLink() {
        if let url = URL(string: viewModel.output.detailData.value.mediaLink), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
