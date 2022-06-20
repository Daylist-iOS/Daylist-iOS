//
//  BaseCollectionViewCell.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/19.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {}
}
