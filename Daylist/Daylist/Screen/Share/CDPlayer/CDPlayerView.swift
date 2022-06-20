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
    
    private(set) var playerCD = UIImageView()
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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -7, height: 5)
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
    
    /// 버튼이 있는 player의 경우 타입에 따라 버튼을 추가해주는 함수
    func configurePlayerBtn(playerType: CDPlayerType, target: Any?, action: Selector) {
        configureBtnLayout()
        playerBtn.setTitle(playerType.playerBtnTitle, for: .normal)
        playerBtn.setImage(playerType.playerBtnImage, for: .normal)
        playerBtn.addTarget(target, action: action, for: .touchUpInside)
    }
    
    /// CD Player 썸네일을 바꿔주는 함수
    func setThumbnailImage(with image: UIImage) {
        playerCD.layer.cornerRadius = playerCD.frame.width / 2
        playerCD.contentMode = .scaleAspectFill
        playerCD.image = image
    }
    
    func getThumbnailImage() -> UIImage {
        return playerCD.image ?? UIImage()
    }
}

// MARK: - Layout
extension CDPlayerView {
    /// player에 따라 선언 및 레이아웃 지정 후 호출하여 내부 constraint를 지정해주는 함수
    func configureLayout(with playerType: CDPlayerType) {
        layer.cornerRadius = playerType.cornerRadius
        backgroundColor = playerType.playerBackgroundColor
        addSubview(playerBaseImage)
        playerBaseImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(playerType.baseInset)
            $0.height.equalTo(playerBaseImage.snp.width)
        }
        
        playerBaseImage.addSubview(playerCD)
        playerCD.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(playerType.CDInset)
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
