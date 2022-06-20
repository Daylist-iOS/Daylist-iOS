//
//  DetailVM.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

protocol DetailViewModelOutput: Lodable {
    var detailData: BehaviorRelay<[DetailResponseModel]> { get }
    var onError: PublishSubject<APIError> { get }
}

final class DetailVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()

    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: DetailViewModelOutput {
        var detailData = BehaviorRelay<[DetailResponseModel]>(value: [])
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

extension DetailVM {
    func bindInput() {}
}

// MARK: - Output

extension DetailVM {
    func bindOutput() {}
}

// MARK: - Networking

extension DetailVM {
    func getDetailData(with detail: DetailRequestModel) {
        let path = "/playlist/\(detail.userId)/\(detail.playlistId)"
        let resource = urlResource<[DetailResponseModel]>(path: path)
        if output.isLoading { return }
        output.beginLoading()
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.output.endLoading()
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let data):
                    owner.output.detailData.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
