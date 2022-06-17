//
//  EmotionCVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit
import SnapKit
import Then

class EmotionCVC: UICollectionViewCell {
    var emoji = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFill
            $0.tintColor = .lightGray
        }
    
    var emotionTitle = UILabel()
        .then {
            $0.font = .KyoboHandwriting(size: 13)
            $0.textAlignment = .center
            $0.textColor = .lightGray
        }
    var emotionType: EmotionType?
    
    private var containerView = UIView()
    
    private var stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 10
        }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        emoji.image = nil
        emotionTitle.text = nil
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                emoji.tintColor = emotionType?.emotionTintColor
                emotionTitle.textColor = emotionType?.emotionTintColor
            }
            else {
                emoji.tintColor = .lightGray
                emotionTitle.textColor = .lightGray
            }
        }
    }
}

// MARK: - Helpers

extension EmotionCVC {
    func configureCell(with emotion: EmotionType) {
        emotionType = emotion
        emoji.image = emotion.emotionImage.withRenderingMode(.alwaysTemplate)
        emotionTitle.text = emotion.emotionTitle
    }
}

// MARK: - Configure

extension EmotionCVC {
    private func configureView() {
        configureSubViews()
    }
    
    private func configureSubViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(emoji)
        stackView.addArrangedSubview(emotionTitle)
    }
}

// MARK: - Layout

extension EmotionCVC {
    private func layoutView() {
        layoutContainerView()
        layoutStackView()
    }
    
    private func layoutContainerView() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
