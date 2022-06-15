//
//  EmotionType.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit

enum EmotionType: CaseIterable {
    case happy
    case flutter
    case comfortable
    case notGood
    case sad
}

extension EmotionType {
    var index: Int {
        switch self {
        case .happy:
            return 0
        case .flutter:
            return 1
        case .comfortable:
            return 2
        case .notGood:
            return 3
        case .sad:
            return 4
        }
    }
    
    var emotionTintColor: UIColor {
        switch self {
        case .happy:
            return UIColor.red
        case .flutter:
            return UIColor.systemPink
        case .comfortable:
            return UIColor.green
        case .notGood:
            return UIColor.darkGray
        case .sad:
            return UIColor.blue
        }
    }
    
    var emotionImage: UIImage {
        switch self {
        case .happy:
            return UIImage(named: "EmotionUnSelected") ?? UIImage()
        case .flutter:
            return UIImage(named: "EmotionUnSelected") ?? UIImage()
        case .comfortable:
            return UIImage(named: "EmotionUnSelected") ?? UIImage()
        case .notGood:
            return UIImage(named: "EmotionUnSelected") ?? UIImage()
        case .sad:
            return UIImage(named: "EmotionUnSelected") ?? UIImage()
        }
    }
    
    var emotionTitle: String {
        switch self {
        case .happy:
            return "신나요"
        case .flutter:
            return "설레요"
        case .comfortable:
            return "평온해요"
        case .notGood:
            return "별로예요"
        case .sad:
            return "슬퍼요"
        }
    }
}
