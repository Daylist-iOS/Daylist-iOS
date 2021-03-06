//
//  APISession.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import Alamofire
import RxSwift

struct APISession: APIService {
    func getRequest<T>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        return Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: GenericResponse<T>.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let decodedData):
                        guard let data = decodedData.data else {
                            print("None-Data")
                            return
                        }
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>> {
        
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: param,
                                  encoding: JSONEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: GenericResponse<T>.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let decodedData):
                        guard let data = decodedData.data else {
                            print("None-Data")
                            return
                        }
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func postRequestWithImage<T: Decodable>(with urlResource: urlResource<T>, param: Parameters, image: UIImage, method: HTTPMethod) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data"
            ]
            
            let task = AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                }
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipart.append(imageData, withName: "files", fileName: "image.png", mimeType: "image/png")
                }
            }, to: urlResource.resultURL, method: method, headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: GenericResponse<T>.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let decodedData):
                        guard let data = decodedData.data else {
                            print("None-Data")
                            return
                        }
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func youtubeSearchRequest<T>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>> where T : Decodable {
        
        return Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  parameters: param,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let decodedData):
                        observer.onNext(.success(decodedData))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
