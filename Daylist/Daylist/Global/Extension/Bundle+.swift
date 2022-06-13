//
//  Bundle+.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "YoutubeInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else {
            fatalError("YoutubeInfo.plist에 API_KEY를 입력해주세요! ")
        }
        
        return key
    }
}
