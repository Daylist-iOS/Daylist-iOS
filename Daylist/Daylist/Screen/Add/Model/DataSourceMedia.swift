//
//  DataSourceMedia.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation
import RxDataSources

struct DataSourceMedia {
    var section: Int
    var items: [Item]
}

extension DataSourceMedia: SectionModelType {
    typealias Item = YoutubeItemResponse
    
    init(original: DataSourceMedia, items: [YoutubeItemResponse]) {
        self = original
        self.items = items
    }
}
