//
//  BaseViewController.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutView()
        bindRx()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func layoutView() {}
    
    func bindRx() {
        bindDependency()
        bindInput()
        bindOutput()
    }
    
    func bindDependency() {}
    
    func bindInput() {}
    
    func bindOutput() {}
}
