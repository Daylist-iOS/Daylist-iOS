//
//  AddModel.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import UIKit
import Alamofire

struct AddModel {
    var userId: Int
    var title: String
    var description: String?
    var thumbnailURL: String
    var mediaLink: String
    var emotion: Int?
    
    init(userId: Int, title: String, description: String?, thumbnailURL: String, mediaLink: String, emotion: Int?) {
        self.userId = userId
        self.title = title
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.mediaLink = mediaLink
        self.emotion = emotion
    }
}

extension AddModel {
    var addParam: Parameters {
        return [
            "userId": 1,
            "title": title,
            "description": description ?? "",
            "mediaLink": mediaLink,
            "emotion": emotion ?? 0
        ]
    }
}
