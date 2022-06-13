//
//  YoutubeListResponse.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation
import Alamofire

struct YoutubeListResponse: Decodable {
    var kind: String
    var etag: String
    var nextPageToken: String
    var prevPageToken: String?
    var pageInfo: PageInfo
    var items: [YoutubeItemResponse]
}

struct PageInfo: Decodable {
    var totalResults: Int
    var resultsPerPage: Int
}
