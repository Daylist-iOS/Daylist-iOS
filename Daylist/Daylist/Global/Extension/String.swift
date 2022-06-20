//
//  String.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/20.
//

import Foundation

extension String {
    
    /// 서버에서 들어온 Date String을 Date 타입으로 반환하는 메서드
    private func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("toDate() convert error")
            return Date()
        }
    }
    
    /// 서버에서 들어온 Date String을 UI에 적용 가능한 String 타입으로 반환하는 메서드
    func serverTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        return dateFormatter.string(from: self.toDate())
    }
}
