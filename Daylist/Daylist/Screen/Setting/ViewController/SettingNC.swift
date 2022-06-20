//
//  SettingNC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import UIKit
import SnapKit

class SettingNC: BaseNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([SettingVC()], animated: true)
    }
}
