//
//  CDPlayerView.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/12.
//

import UIKit
import SnapKit
import Then

class CDPlayerView: BaseView {
    private var playerBaseImage = UIImageView()
        .then {
            $0.image = UIImage(named: "PlayerBase")
        }
    
    private var playerCD = UIImageView()
        .then {
            $0.clipsToBounds = true
        }
    
    private let playerCenterImage = UIImageView()
        .then {
            $0.image = UIImage(named: "PlayerCenter")
        }
    
    private var playerBtn = UIButton()
        .then {
            $0.backgroundColor = .playerBtn
            $0.titleLabel?.textColor = .white
            $0.titleLabel?.font = .KyoboHandwriting(size: 12)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.layer.cornerRadius = 12
        }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
}

// MARK: - Configure
extension CDPlayerView {
    private func configureContentView() {
        backgroundColor = .playerBase
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -7, height: 5)
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
    
    func configurePlayerBtn(playerType: CDPlayerType, target: Any?, action: Selector) {
        configureBtnLayout()
        playerBtn.setTitle(playerType.playerBtnTitle, for: .normal)
        playerBtn.setImage(playerType.playerBtnImage, for: .normal)
        playerBtn.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setThumbnailImage(with image: UIImage) {
        playerCD.contentMode = .scaleAspectFill
        playerCD.image = image
    }
}

// MARK: - Layout
extension CDPlayerView {
    func configureLayout(with playerType: CDPlayerType) {
        layer.cornerRadius = playerType.cornerRadius
        addSubview(playerBaseImage)
        playerBaseImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(playerType.inset)
            $0.height.equalTo(playerBaseImage.snp.width)
        }
        
        playerBaseImage.addSubview(playerCD)
        playerCD.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(playerBaseImage.frame.width / 24)
        }
        
        playerCD.addSubview(playerCenterImage)
        playerCenterImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().dividedBy(5.0)
        }
    }
    
    private func configureBtnLayout() {
        addSubview(playerBtn)
        playerBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(68)
            $0.trailing.equalToSuperview().offset(-68)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(24)
        }
    }
}
