//
//  EmotionType.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit

enum EmotionType: Int, CaseIterable {
    case happy = 0
    case flutter = 1
    case comfortable = 2
    case notGood = 3
    case sad = 4
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
            return .emotionHappy
        case .flutter:
            return .emotionFlutter
        case .comfortable:
            return .emotionComfortable
        case .notGood:
            return .emotionNotGood
        case .sad:
            return .emotionSad
        }
    }
    
    var emotionImage: UIImage {
        switch self {
        case .happy:
            return UIImage(named: "Happy") ?? UIImage()
        case .flutter:
            return UIImage(named: "Flutter") ?? UIImage()
        case .comfortable:
            return UIImage(named: "Comfortable") ?? UIImage()
        case .notGood:
            return UIImage(named: "NotGood") ?? UIImage()
        case .sad:
            return UIImage(named: "Sad") ?? UIImage()
        }
    }
    
    var emotionUnselectedImage: UIImage {
        switch self {
        case .happy:
            return UIImage(named: "Happy_UnSelected") ?? UIImage()
        case .flutter:
            return UIImage(named: "Flutter_UnSelected") ?? UIImage()
        case .comfortable:
            return UIImage(named: "Comfortable_UnSelected") ?? UIImage()
        case .notGood:
            return UIImage(named: "NotGood_UnSelected") ?? UIImage()
        case .sad:
            return UIImage(named: "Sad_UnSelected") ?? UIImage()
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
