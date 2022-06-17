//
//  Loadable.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation
import RxCocoa

protocol Lodable {
    var loading: BehaviorRelay<Bool> { get }
}

extension Lodable {
    var isLoading: Bool {
        loading.value
    }
    
    func beginLoading() {
        loading.accept(true)
    }
    
    func endLoading() {
        loading.accept(false)
    }
}
