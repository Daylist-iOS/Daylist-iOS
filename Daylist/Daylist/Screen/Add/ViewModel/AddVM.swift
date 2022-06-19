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
    var media:  PublishRelay<EmbedModel> { get }
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
        var addResponseSuccess = PublishSubject<Bool>()
        var media = PublishRelay<EmbedModel>()
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
        let path = "/playlist"
        let resource = urlResource<MediaResponse>(path: path)
        if output.isLoading { return }
        output.beginLoading()
        
        apiSession.postRequestWithImage(with: resource,
                                        param: media.addParam,
                                        image: media.thumbnailImage,
                                        method: .post)
        .withUnretained(self)
        .subscribe(onNext: { owner, result in
            owner.output.endLoading()
            switch result {
            case .failure(let error):
                owner.apiError.onNext(error)
                
            case .success(let data):
                dump(data)
                owner.output.addResponseSuccess.onNext(true)
            }
        })
        .disposed(by: bag)
    }
}
