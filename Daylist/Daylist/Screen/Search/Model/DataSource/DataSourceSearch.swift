//
//  DataSourceSearch.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import Foundation
import RxDataSources

struct DataSourceSearch {
    var section: Int
    var items: [Item]
}

extension DataSourceSearch: SectionModelType {
    typealias Item = SearchDataResponse
    
    init(original: DataSourceSearch, items: [SearchDataResponse]) {
        self = original
        self.items = items
    }
}
