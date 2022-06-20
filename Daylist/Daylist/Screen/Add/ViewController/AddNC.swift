//
//  AddNC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit
import SnapKit

class AddNC: BaseNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([AddVC()], animated: true)
    }
}
