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
    /// 플레이어의 커브값을 지정하는 변수
    var cornerRadius: CGFloat {
        switch self {
        case .home:
            return 28
        case .detail, .add:
            return (UIScreen.main.bounds.size.width - 57 * 2) / 4.3
        }
    }
    
    var baseInset: CGFloat {
        switch self {
        case .home:
            return 11
        case .detail, .add:
            return 26
        }
    }
    
    /// 플레이어와 CD 사이의 간격을 지정하는 변수
    var CDInset: CGFloat {
        switch self {
        case .home:
            return 3
        case .detail, .add:
            return 8
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
    
    var playerBackgroundColor: UIColor {
        switch self {
        case .home:
            return .white
        default:
            return .playerBase
        }
    }
}
