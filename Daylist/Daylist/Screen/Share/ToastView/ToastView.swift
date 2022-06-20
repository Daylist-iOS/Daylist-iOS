//
//  ToastView.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/20.
//

import UIKit
import SnapKit
import Then

class ToastView: BaseView {
    private var message = UILabel()
        .then {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = .systemBackground
        }
    
    override func configureView() {
        addSubview(message)
        backgroundColor = .label
        layer.opacity = 0.7
        layer.cornerRadius = 5
    }
    
    override func layoutView() {
        message.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Custom Methods
extension ToastView {
    func setMessage(message: String) {
        self.message.text = message
    }
}
