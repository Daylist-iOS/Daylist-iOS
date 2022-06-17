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


// MARK: - Input

extension YoutubeSearchVM {
    func bindInput() {}
}

// MARK: - Output

extension YoutubeSearchVM {
    func bindOutput() {}
}

extension YoutubeSearchVM {
    func getSearchResult(with keyword: String) {
        if output.isLoading { return }

        output.loading.accept(true)
        
        var optionParams: Parameters {
            return [
                "q": keyword,
                "part": "snippet",
                "key": Bundle.main.apiKey,
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
                    owner.output.loading.accept(false)
                    let medias = data.items
                    owner.output.medias.accept(medias)
                case .failure(let error):
                    owner.output.onError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
}
