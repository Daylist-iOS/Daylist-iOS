//
//  YoutubeSearchTVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class YoutubeSearchTVC: UITableViewCell {
    var thumbnail = UIImageView()
        .then {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .white
            $0.kf.indicatorType = .activity
        }
    
    var titleLabel = UILabel()
        .then {
            $0.font = .KyoboHandwriting(size: 16)
            $0.textAlignment = .left
            $0.setLineBreakMode()
            $0.numberOfLines = 2
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
    
    var channelTitle = UILabel()
        .then {
            $0.font = .KyoboHandwriting(size: 14)
            $0.textColor = .darkGray
            $0.textAlignment = .left
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
    
    var youtubeURL = UILabel()
        .then {
            $0.font = .KyoboHandwriting(size: 14)
            $0.textColor = .darkGray
            $0.textAlignment = .left
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
    
    private var containerView = UIView()
    
    private var stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
        }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        layoutView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.kf.cancelDownloadTask()
        thumbnail.image = nil
        titleLabel.text = nil
        youtubeURL.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20))
    }
}

// MARK: - Helpers

extension YoutubeSearchTVC {
    func configureCell(with media: YoutubeItemResponse, with size: CGSize) {
        let processor = DownsamplingImageProcessor(size: size)
        thumbnail.kf.setImage(with: media.snippet.thumbnails.thumbnailURL,
                                       placeholder: UIImage(),
                                       options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .cacheOriginalImage,
                                       ])
        thumbnail.contentMode = .scaleAspectFill
        
        titleLabel.text = media.snippet.title
        channelTitle.text = media.snippet.channelTitle
        youtubeURL.text = "https://www.youtube.com/watch?v=\(media.id.videoId)"
    }
}

// MARK: - Configure

extension YoutubeSearchTVC {
    private func configureView() {
        configureSubViews()
    }
    
    private func configureSubViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(thumbnail)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(channelTitle)
        stackView.addArrangedSubview(youtubeURL)
    }
}

// MARK: - Layout

extension YoutubeSearchTVC {
    private func layoutView() {
        layoutContainerView()
        layoutThumbnailImageView()
        layoutStackView()
    }
    
    private func layoutContainerView() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutThumbnailImageView() {
        thumbnail.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(thumbnail.snp.height)
        }
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(thumbnail.snp.trailing).offset(10)
        }
    }
}
