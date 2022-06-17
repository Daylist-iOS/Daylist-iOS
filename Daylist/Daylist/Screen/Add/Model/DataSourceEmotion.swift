//
//  DataSourceEmotion.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/14.
//

import Foundation
import RxDataSources

struct DataSourceEmotion {
    var section: Int
    var items: [Item]
}

extension DataSourceEmotion: SectionModelType {
    typealias Item = EmotionType
    
    init(original: DataSourceEmotion, items: [EmotionType]) {
        self = original
        self.items = items
    }
}
