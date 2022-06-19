//
//  LockType.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import Foundation

enum LockType {
    case enter
    case changePW
    case checkPW
}

extension LockType {
    var message: String {
        switch self {
        case .enter:
            return "잠금 해제를 위한 암호를 입력해 주세요."
        case .changePW:
            return "새로운 암호를 입력해 주세요."
        case .checkPW:
            return "확인을 위해 한 번 더 입력해 주세요."
        }
    }
}
