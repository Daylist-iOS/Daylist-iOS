//
//  UITableView+.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import Foundation
import UIKit

extension UITableView {
    
    /// TableView 마지막 separator, 빈 셀 separator 숨기는 메서드
    func removeSeparatorsOfEmptyCellsAndLastCell() {
        tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
    }
}
