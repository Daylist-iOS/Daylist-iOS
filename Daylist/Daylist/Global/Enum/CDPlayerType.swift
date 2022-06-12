//
//  CDPlayerType.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/12.
//

import UIKit

enum CDPlayerType {
    case home
    case detail
    case add
}

extension CDPlayerType {
    var cornerRadius: CGFloat {
        switch self {
        case .home:
            return 28
        case .detail, .add:
            return (UIScreen.main.bounds.size.width - 57 * 2) / 4.3
        }
    }
    
    var inset: CGFloat {
        switch self {
        case .home:
            return 11
        case .detail, .add:
            return 26
        }
    }
    
    var playerBtnTitle: String {
        switch self {
        case .home:
            return ""
        case .detail:
            return "미디어 보러가기 "
        case .add:
            return "커버 이미지 변경하기 "
        }
    }
    
    var playerBtnImage: UIImage {
        switch self {
        case .home:
            return UIImage()
        case .detail:
            return UIImage(named: "Youtube")!
        case .add:
            return UIImage(named: "Edit")!
        }
    }
}
