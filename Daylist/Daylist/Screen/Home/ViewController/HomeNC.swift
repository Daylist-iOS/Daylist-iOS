//
//  HomeNC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/18.
//

import UIKit

class HomeNC: BaseNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([HomeVC()], animated: true)
    }
}
