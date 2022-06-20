//
//  ToastType.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/20.
//

import Foundation

enum ToastType: String {
    case changeUIUserInterfaceStyle
    case addMedia
    case changePW
    case chooseAll
}

extension ToastType {
    var message: String {
        switch self {
        case .changeUIUserInterfaceStyle:
            return UserDefaults.standard.string(forKey: "Appearance") == "Dark"
            ? "다크모드로 변경되었습니다."
            : "라이트모드로 변경되었습니다."
        case .addMedia:
            return "미디어가 등록되었습니다."
        case .changePW:
            return "암호가 변경되었습니다."
        case .chooseAll:
            return "모든 항목을 선택해 주세요."
        }
    }
}
