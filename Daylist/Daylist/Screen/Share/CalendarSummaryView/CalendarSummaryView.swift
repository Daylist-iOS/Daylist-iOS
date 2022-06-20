//
//  CalendarSummaryView.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/18.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class CalendarSummaryView: BaseView {
    
    // MARK: Properties
    
    private(set) var cdPlayerView = CDPlayerView()
    
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
    
    private let descriptionTextView = UITextView().then {
        $0.textColor = .lightDarkGray
        $0.font = UIFont.KyoboHandwriting(size: 10.0)
        $0.backgroundColor = .none
        $0.isEditable = false
    }
    
    private let noneTextView = UITextView().then {
        $0.textColor = .lightDarkGray
        $0.font = UIFont.KyoboHandwriting(size: 12.0)
        $0.backgroundColor = .none
        $0.isEditable = false
    }
    
    private let stylusImageView = UIImageView().then {
        $0.image = UIImage(named: "stylus")
    }
    
    // MARK: Variables
    
    var isHome: Bool?
    
    override func layoutView() {
        configureUI()
    }
    
    override func configureView() {
        cdPlayerView.configureLayout(with: .home)
    }
}

// MARK: - UI

extension CalendarSummaryView {
    private func configureUI() {
        self.addSubviews([cdPlayerView, dateLabel, titleStackView, descriptionTextView, stylusImageView])
        titleStackView.addArrangedSubview(emotionImageView)
        titleStackView.addArrangedSubview(titleLabel)
        
        cdPlayerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 113.adjustedH))
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
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(5)
            $0.leading.equalTo(titleStackView.snp.leading)
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
    
    func setBackgroundColor(isHome: Bool) {
        self.backgroundColor = isHome ? .homeGray : .white
    }
}

// MARK: - Custom Methods

extension CalendarSummaryView {
    func setData(isData: CalendarSummaryType, model: CalendarSummaryModel) {
        switch isData {
        case .none:
            setSummaryViewProperties(isHidden: true, model: model)
            setSummaryViewWhenNoneData()
            descriptionTextView.text = "기록된 데일리스트가 없습니다"
        case .today:
            if model.title == "" && model.description == "" {
                setSummaryViewProperties(isHidden: true, model: model)
                setSummaryViewWhenNoneData()
                descriptionTextView.text = "오늘의 데일리스트가 없습니다. \n오늘 하루 인상깊었던 미디어를 기록해보세요!"
            } else {
                setSummaryViewProperties(isHidden: false, model: model)
                setSummaryViewWhenDataExist()
            }
        case .exist:
            setSummaryViewProperties(isHidden: false, model: model)
            setSummaryViewWhenDataExist()
        }
    }
    
    private func setSummaryViewWhenNoneData() {
        descriptionTextView.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleStackView)
            $0.trailing.equalTo(stylusImageView.snp.leading).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func setSummaryViewWhenDataExist() {
        descriptionTextView.snp.remakeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(5)
            $0.leading.equalTo(titleStackView)
            $0.trailing.equalTo(stylusImageView.snp.leading).offset(-20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setSummaryViewProperties(isHidden: Bool, model: CalendarSummaryModel) {
        [dateLabel, emotionImageView, titleLabel].forEach {
            $0.isHidden = isHidden
        }

        dateLabel.text = model.date
        titleLabel.text = model.title
        descriptionTextView.text = model.description
        emotionImageView.image = model.emotion.emotionImage
        
        if isHidden {
            self.cdPlayerView.setThumbnailImage(with: UIImage())
        } else {
            guard let thumbnailURL = URL(string: model.thumbnailImageName) else { return }
            KingfisherManager.shared.retrieveImage(with: thumbnailURL) { image in
                switch image {
                case .success(let imageData):
                    self.cdPlayerView.setThumbnailImage(with: imageData.image)
                case .failure:
                    return
                }
            }
        }
    }
}
