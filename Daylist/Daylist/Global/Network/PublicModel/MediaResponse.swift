//
//  MediaResponse.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/17.
//

import Foundation

struct MediaResponse: Decodable {
    var playlistId: Int
    var userId: Int
    var title: String
    var description: String
    var thumbnailImage: String
    var mediaLink: String
    var emotion: Int
    var createdAt: String
}
