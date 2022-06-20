//
//  WeekCVC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/19.
//

import UIKit
import SnapKit
import Then

class WeekCVC: BaseCollectionViewCell {
    
    private(set) var weekLabel = UILabel().then {
        $0.font = UIFont.KyoboHandwriting(size: 14.0)
    }

    override func setupViews() {
        configureUI()
    }
}

// MARK: - UI

extension WeekCVC {
    private func configureUI() {
        self.addSubview(weekLabel)
        
        weekLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Custom Methods

extension WeekCVC {
    func setData(weekString: String) {
        weekLabel.text = weekString
    }
}


