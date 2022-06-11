//
//  BaseView.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import SnapKit
import Then
import UIKit

class BaseView: UIView {
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
    
    func configureView() {}
    
    func layoutView() {}
}
