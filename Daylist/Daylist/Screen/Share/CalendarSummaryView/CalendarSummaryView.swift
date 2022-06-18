//
//  CalendarSummaryView.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/18.
//

import UIKit
import SnapKit
import Then

class CalendarSummaryView: UIView {
    
    // MARK: Properties
    
    private var cdPlayerView = CDPlayerView()
    
    private var thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 38
        $0.clipsToBounds = true
    }
    
    private var playerCenterImageView = UIImageView().then {
        $0.image = UIImage(named: "PlayerCenter")
    }
    
    private var dateLabel = UILabel().then {
        $0.textColor = .mediumGray
        $0.font = UIFont.KyoboHandwriting(size: 10.0)
        $0.letterSpacing = 0.18
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    private let emotionImageView = UIImageView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.KyoboHandwriting(size: 15.0)
        $0.letterSpacing = -0.24
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .lightDarkGray
        $0.font = UIFont.KyoboHandwriting(size: 10.0)
        $0.letterSpacing = -0.24
        $0.numberOfLines = 0
    }
    
    private let stylusImageView = UIImageView().then {
        $0.image = UIImage(named: "stylus")
    }
    
    // MARK: Variables
    
    var isHome: Bool?
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        cdPlayerView.configureLayout(with: .home)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        cdPlayerView.configureLayout(with: .home)
    }
}

// MARK: - UI

extension CalendarSummaryView {
    private func configureUI() {
        self.addSubviews([cdPlayerView, dateLabel, titleStackView, descriptionLabel, stylusImageView])
        titleStackView.addArrangedSubview(emotionImageView)
        titleStackView.addArrangedSubview(titleLabel)
        
        cdPlayerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 113))
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.height.equalTo(24)
            $0.leading.equalTo(cdPlayerView.snp.trailing).offset(27)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.leading.equalTo(dateLabel)
            $0.trailing.equalTo(stylusImageView.snp.leading).inset(27)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 20))
        }
        
        emotionImageView.snp.makeConstraints {
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 20))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 20) * 21 / 20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleStackView)
            $0.trailing.equalTo(stylusImageView.snp.leading).offset(-20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        stylusImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(13)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 106))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 106) * 8 / 106)
        }
    }
}

// MARK: - Custom Methods

extension CalendarSummaryView {
    func setData(isHome: Bool, model: CalendarSummaryModel) {
        self.backgroundColor = isHome ? .homeGray : .white
        cdPlayerView.setThumbnailImage(with: UIImage(named: model.thumbnailImageName) ?? UIImage())
        dateLabel.text = model.date
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        emotionImageView.image = model.emotion.emotionImage
    }
}
