//
//  DetailResponseModel.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import Foundation

// MARK: - DetailResponseModel
struct DetailResponseModel: Codable {
    let playlistID, userID: Int
    let title, description: String
    let thumbnailImage: String
    let mediaLink: String
    let emotion: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case playlistID = "playlistId"
        case userID = "userId"
        case title
        case thumbnailImage, description, mediaLink, emotion, createdAt
    }
}
