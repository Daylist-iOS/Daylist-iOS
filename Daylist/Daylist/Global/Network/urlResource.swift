//
//  urlResource.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/17.
//

import Foundation

struct urlResource<T: Decodable> {
    let baseURL = URL(string: "https://asia-northeast3-daylist-65de6.cloudfunctions.net/server")
    let path: String
    var resultURL: URL {
        return path.contains("http")
        ? URL(string: path)!
        : baseURL.flatMap { URL(string: $0.absoluteString + path) }!
    }
    
    func judgeError(statusCode: Int) -> Result<T, APIError> {
        switch statusCode {
        case 400...409: return .failure(.decode)
        case 500: return .failure(.http(status: statusCode))
        default: return .failure(.unknown)
        }
    }
}
