//
//  AddVM.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//

import RxCocoa
import RxSwift

protocol AddViewModelOutput: Lodable {
    var emotions: Observable<[EmotionType]> { get }
    
    var onError: PublishSubject<APIError> { get }
    
    var dataSource: Observable<[DataSourceEmotion]> { get }
}

extension AddViewModelOutput {
    var dataSource: Observable<[DataSourceEmotion]> {
        emotions
            .map {
                return [DataSourceEmotion(section: 0, items: $0)]
            }
    }
}

final class AddVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: AddViewModelOutput {
        var emotions = Observable<[EmotionType]>.from([EmotionType.allCases])
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

extension AddVM {
    func bindInput() {}
}

// MARK: - Output

extension AddVM {
    func bindOutput() {}
}

// MARK: - Networking

extension AddVM {
    func postMediaData(with media: AddModel) {
        let baseURL = "https://asia-northeast3-daylist-65de6.cloudfunctions.net/server/playlist"
        let url = URL(string: baseURL)!
        let resource = urlResource<String>(url: url)
        
        apiSession.postRequest(with: resource, param: media.addParam)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let data):
                    dump(data)
                }
            })
            .disposed(by: bag)
    }
}
