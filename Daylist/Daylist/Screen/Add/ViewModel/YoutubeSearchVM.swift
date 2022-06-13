//
//  YoutubeSearchVM.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

protocol Lodable {
    var loading: BehaviorRelay<Bool> { get }
}

extension Lodable {
    var isLoading: Bool {
        loading.value
    }
    
    func beginLoading() {
        loading.accept(true)
    }
    
    func endLoading() {
        loading.accept(false)
    }
}

protocol YoutubeListViewModelOutput: Lodable {
    var medias: BehaviorRelay<[YoutubeItemResponse]> { get }
    
    var onError: PublishSubject<APIError> { get }
    
    var dataSource: Observable<[DataSourceMedia]> { get }
}

extension YoutubeListViewModelOutput {
    var dataSource: Observable<[DataSourceMedia]> {
        medias
            .map {
                [DataSourceMedia(section: 0, items: $0)]
            }
    }
}

final class YoutubeSearchVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: YoutubeListViewModelOutput {
        
        // TODO: 06. Conform NewsListViewModelOutput Protocol
        //BehaviorRelay는 어디선가 구독하면 초기값부터 구독하기때문에
        var medias = BehaviorRelay<[YoutubeItemResponse]>(value: [])
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

// MARK: - Helpers

extension YoutubeSearchVM {
    func fetchAll() {
        getSearchResult()
    }
}

// MARK: - Input

extension YoutubeSearchVM {
    func bindInput() {}
}

// MARK: - Output

extension YoutubeSearchVM {
    func bindOutput() {}
}

extension YoutubeSearchVM {
    private func getSearchResult() {
        var optionParams: Parameters {
            return [
                "q": "playlist",
                "part": "snippet",
                "key": "API Key",
                "type": "video",
                "maxResults": 10,
                "regionCode": "KR"
            ]
        }
        
        guard let url = URL(string:"https://www.googleapis.com/youtube/v3/search?") else { return }
        let resource = urlResource<YoutubeListResponse>(url: url)
        
        apiSession.getRequest(with: resource, param: optionParams)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    dump(data)
                    let medias = data.items
                    owner.output.medias.accept(medias)
                case .failure(let error):
                    owner.output.onError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
}
