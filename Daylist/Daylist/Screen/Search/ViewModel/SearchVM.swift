//
//  SearchVM.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

// MARK: - SearchViewModelOutput

protocol SearchViewModelOutput: Lodable {
    var searchData: BehaviorRelay<[SearchDataResponse]> { get }
    
    var onError: PublishSubject<APIError> { get }
    
    var dataSource: Observable<[DataSourceSearch]> { get }
}

extension SearchViewModelOutput {
    var dataSource: Observable<[DataSourceSearch]> {
        searchData
            .map {
                [DataSourceSearch(section: 0, items: $0)]
            }
    }
}

// MARK: - SearchVM

final class SearchVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: SearchViewModelOutput {
        var searchData = BehaviorRelay<[SearchDataResponse]>(value: [])
        var onError = PublishSubject<APIError>()
        var loading = BehaviorRelay<Bool>(value: false)
    }
    
    // MARK: - Init
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Input

extension SearchVM {
    func bindInput() {}
}

// MARK: - Output

extension SearchVM {
    func bindOutput() {}
}

// MARK: - Networking

extension SearchVM {
    func postSearchData(with param: SearchDataRequest) {
        let path = "/search/\(param.userId)"
        let resource = urlResource<[SearchDataResponse]>(path: path)
        if output.isLoading { return }
        output.beginLoading()
        
        apiSession.postRequest(with: resource, param: ["keyword": param.keyword])
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.output.endLoading()
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let data):
                    owner.output.searchData.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
