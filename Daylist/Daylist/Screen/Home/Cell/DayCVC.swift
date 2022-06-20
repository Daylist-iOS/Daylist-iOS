//
//  DayCVC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/19.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class DayCVC: BaseCollectionViewCell {
    
    private var cdImageView = UIImageView()
    private var thumbnailImageView = UIImageView()
    private var emotionImageView = UIImageView()
    private(set) var dayLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.KyoboHandwriting(size: 13.0)
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        emotionImageView.image = nil
    }
    
    override func setupViews() {
        configureUI()
    }
    
    override func layoutSubviews() {
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.layer.frame.height / 2
        thumbnailImageView.layer.masksToBounds = true
    }
}

// MARK: - UI

extension DayCVC {
    private func configureUI() {
        self.addSubviews([thumbnailImageView, cdImageView, emotionImageView, dayLabel])
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 38))
        }
        
        cdImageView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(thumbnailImageView)
            $0.width.height.equalTo(thumbnailImageView)
        }
        
        emotionImageView.snp.makeConstraints {
            $0.bottom.trailing.equalTo(cdImageView)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 14))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 14) * 15 / 14)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerX.equalTo(thumbnailImageView)
            $0.top.equalTo(cdImageView.snp.bottom).offset(3)
        }
    }
}

// MARK: - Custom Methods

extension DayCVC {
    func setData(model: CalendarDataResponse, dayString: String) {
        dayLabel.text = dayString
        cdImageView.image = UIImage(named: model.playlistID == 0 ? "dayCell_empty" : "dayCell_fill")
        emotionImageView.image = model.playlistID == 0 ? nil : EmotionType(rawValue: model.emotion)?.emotionImage
        downloadThumbnailImage(url: model.thumbnailImage)
    }
    
    private func downloadThumbnailImage(url: String) {
        guard let url = URL(string: url) else { return }
        thumbnailImageView.kf.setImage(with: url)
    }
}
