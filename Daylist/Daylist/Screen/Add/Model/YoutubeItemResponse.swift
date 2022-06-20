//
//  YoutubeSearchResponse.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation

struct YoutubeItemResponse: Decodable {
    var kind: String
    var etag: String
    var id: Id
    var snippet: Snippet
}

struct Id: Decodable {
    var kind: String
    var videoId: String
    var channelId: String?
    var playlistId: String?
}

struct Snippet: Decodable {
    var publishedAt: String
    var channelId: String
    var title: String
    var description: String
    var thumbnails: Thumbnails
    var channelTitle: String
}

struct Thumbnails: Decodable {
    var `default`: Thumbnail?
    var medium: Thumbnail?
    var high: Thumbnail?
}

struct Thumbnail: Decodable {
    var url: String
    var width: Int
    var height: Int
}

extension Thumbnails {
    var thumbnailURL: String? {
        return medium?.url != nil ? medium!.url : `default`?.url ?? ""
    }
}
