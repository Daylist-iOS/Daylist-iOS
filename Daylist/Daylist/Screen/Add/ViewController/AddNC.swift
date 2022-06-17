//
//  AddNC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit
import SnapKit

class AddNC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedContentVC()
    }
}

// MARK: - Configure
extension AddNC {
    private func embedContentVC() {
        setNavigationBarHidden(true, animated: false)
        let subVC = AddVC()
        addChild(subVC)
        navigationController?.didMove(toParent: self)
    }
}
