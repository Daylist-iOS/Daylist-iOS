//
//  SearchDataResponse.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import Foundation

// MARK: - SearchDataResponse
struct SearchDataResponse: Codable {
    let playlistID, userID: Int
    let title, description, thumbnailImage, mediaLink: String
    let emotion: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case playlistID = "playlistId"
        case userID = "userId"
        case title
        case thumbnailImage, description, mediaLink, emotion, createdAt
    }
}
