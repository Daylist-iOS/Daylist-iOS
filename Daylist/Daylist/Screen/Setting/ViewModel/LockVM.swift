//
//  LockVM.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import Foundation
import RxCocoa
import RxSwift


final class LockVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {
        var enterPW = PublishSubject<String>()
        var changePW = PublishSubject<[String]>()
    }
    
    // MARK: - Output
    
    struct Output {
        var isValidPW = BehaviorSubject(value: false)
    }
    
    // MARK: - Init
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Helpers

extension LockVM {
    private func changePW(newPW: String, prevPW: String) -> Bool {
        if newPW == prevPW {
            UserDefaults.standard.set(newPW, forKey: UserDefaults.Keys.lockPasswd)
            return true
        } else {
            return false
        }
    }
    
    private func checkEnter(inputPW: String) -> Bool {
        return inputPW == UserDefaults.standard.string(forKey: UserDefaults.Keys.lockPasswd)
    }
}

// MARK: - Input

extension LockVM {
    func bindInput() {
        _ = input.enterPW
            .map(checkEnter)
            .bind(to: output.isValidPW)
        
        _ = input.changePW
            .map{self.changePW(newPW: $0[0], prevPW: $0[1])}
            .bind(to: output.isValidPW)
    }
}

// MARK: - Output

extension LockVM {
    func bindOutput() { }
}
