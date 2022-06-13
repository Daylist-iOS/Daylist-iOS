//
//  APIService.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import Alamofire
import RxSwift

protocol APIService {
    func getRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters?) -> Observable<Result<T, APIError>>
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>>
    
    func postRequestWithImages<T: Decodable>(with urlResource: urlResource<T>, param: Parameters, images: [UIImage], method: HTTPMethod) -> Observable<Result<T, APIError>>
}

