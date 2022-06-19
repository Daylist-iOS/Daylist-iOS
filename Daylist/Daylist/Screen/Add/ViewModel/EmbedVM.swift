//
//  EmbedVM.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftSoup

final class EmbedVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input { }
    
    // MARK: - Output
    
    struct Output {
        var isURLValid = BehaviorSubject(value: false)
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

extension EmbedVM {
    func bindInput() { }
}

// MARK: - Output

extension EmbedVM {
    func bindOutput() { }
}

// MARK: - Networking

extension EmbedVM {
    func getURLMetaData(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        do {
            let html = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(html)
            let title: String? = try doc.head()?.select("meta[property=og:title]").first()?.attr("content")
            let thumbnailURL: String? = try doc.head()?.select("meta[property=og:image]").first()?.attr("content")
            let mediaURL: String? = try doc.head()?.select("meta[property=og:url]").first()?.attr("content")
            let media = EmbedModel(title: title ?? "",
                                   thumbnailURL: thumbnailURL ?? "",
                                   mediaURL: mediaURL ?? "")
            output.media.accept(media)
            output.isURLValid.onNext(true)
        } catch {
            print("잘못된 url 입니다")
            output.isURLValid.onNext(false)
        }
    }
}
