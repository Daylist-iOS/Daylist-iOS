//
//  SettingNC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import UIKit
import SnapKit

class SettingNC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedContentVC()
    }
}

// MARK: - Configure
extension SettingNC {
    private func embedContentVC() {
        setNavigationBarHidden(true, animated: false)
        let subVC = SettingVC()
        addChild(subVC)
        navigationController?.didMove(toParent: self)
    }
}
