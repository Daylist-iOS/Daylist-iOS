//
//  CalendarDataResponse.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/19.
//

import Foundation

// MARK: - CalendarDataResponse

struct CalendarDataResponse: Codable {
    let playlistID, userID: Int
    let title, description, thumbnailImage, mediaLink: String
    let emotion: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case playlistID = "playlistId"
        case userID = "userId"
        case title
        case description, thumbnailImage, mediaLink, emotion, createdAt
    }
}
