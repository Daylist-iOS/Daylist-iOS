//
//  AddNC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit
import SnapKit

class AddNC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedContentVC()
    }
}

// MARK: - Configure
extension AddNC {
    private func embedContentVC() {
        let subVC = AddVC()
        let navigationController = UINavigationController(rootViewController: subVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(navigationController.view)
        navigationController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addChild(navigationController)
        navigationController.didMove(toParent: self)
    }
}
