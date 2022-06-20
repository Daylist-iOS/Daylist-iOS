//
//  HomeVM.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/18.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

protocol HomeViewModelOutput: Lodable {
    var onError: PublishSubject<APIError> { get }
}

final class HomeVM: BaseViewModel {
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: Variables
    private let now = Date()
    private var cal = Calendar.current
    private let dateFormatter = DateFormatter()
    private lazy var engMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    private lazy var engDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy\nMMMM"
        return formatter
    }()
    private lazy var monthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "YYYY.MM.dd EEE"
        return formatter
    }()
    private var components = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var selectedPlaylistId = BehaviorRelay<Int>(value: 0)
    private var daysCountInMonth = 0 // 해당 월이 며칠까지 있는지
    private var weekdayAdding = 0 // 시작일
    private(set) var dayData = BehaviorRelay<[CalendarDataResponse]>(value: [])
    private(set) var summaryData = BehaviorRelay<[CalendarSummaryModel]>(value: [CalendarSummaryModel(thumbnailImageName: "", date: "", emotion: EmotionType(rawValue: 0) ?? .happy, title: "", description: "")])
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: HomeViewModelOutput {
        var dayData = BehaviorRelay<[CalendarDataResponse]>(value: [])
        var onError = PublishSubject<APIError>()
        var loading = BehaviorRelay<Bool>(value: false)
    }
    
    // MARK: - Init
    
    init() {
        initView()
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Input

extension HomeVM {
    func bindInput() {}
}

// MARK: - Output

extension HomeVM {
    func bindOutput() {}
}

// MARK: - Custom Methods
extension HomeVM {
    
    /// 초기 월 표시 포맷 설정하는 메서드
    private func initView() {
        dateFormatter.dateFormat = "yyyy년 \nM월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
    }
    
    /// 월 별 일 수 계산하는 메서드
    func calculation(type: CalendarCalculateType) -> [Int] {
        guard let month = components.month else { return [] }
        
        switch type {
        case .last:
            components.month =  month - 1
        case .current:
            components.month =  month
        case .next:
            components.month =  month + 1
        }
        
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        
        self.days.removeAll()
        
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
        
        guard let year = components.year,
              let month = components.month else { return [] }
        
        return [year, month]
    }
    
    /// YYYY\nMM 형태의 헤더 뷰 속성을 세팅하여 attributedString을 반환하는 메서드
    func setUpHeaderString() -> NSMutableAttributedString {
        let firstDayOfMonth = cal.date(from: components) ?? .now
        let attributedString = NSMutableAttributedString(string: self.engDateFormatter.string(from: firstDayOfMonth))
        
        let attributes0: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont.KyoboHandwriting(size: 20.0)
        ]
        
        let attributes1: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont.KyoboHandwriting(size: 30.0),
            .kern: -1
        ]
        
        attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: 4))
        attributedString.addAttributes(attributes1, range: NSRange(location: 5, length: engMonthFormatter.string(from: firstDayOfMonth).count))
        
        return attributedString
    }
}

// MARK: - Networking

extension HomeVM {
    func getCalendarData(with calendar: CalendarRequestModel) {
        let path = "/main/\(calendar.userId)/\(calendar.year)/\(calendar.month)"
        let resource = urlResource<[CalendarDataResponse]>(path: path)
        if output.isLoading { return }
        output.beginLoading()
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { [self] owner, result in
                owner.output.endLoading()
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    
                case .success(let data):
                    var allDayData: [CalendarDataResponse ] = []
                    for i in days {
                        allDayData.append(CalendarDataResponse(playlistID: 0, userID: 0, title: "", description: "", thumbnailImage: "", mediaLink: "", emotion: 0, createdAt: i))
                    }
                    
                    let todayDay = String(describing: cal.component(.day, from: now))
                    
                    if data.count != 0 {
                        for i in 0...data.count - 1 {
                            for j in 0...allDayData.count - 1 {
                                if allDayData[j].createdAt == data[i].createdAt.serverTimeToString(dateFormat: "d") {
                                    allDayData[j] = data[i]
                                    
                                    // 오늘
                                    if todayDay == data[i].createdAt.serverTimeToString(dateFormat: "d") {
                                        owner.summaryData.accept([CalendarSummaryModel(thumbnailImageName: data[i].thumbnailImage, date: data[i].createdAt, emotion: EmotionType(rawValue: data[i].emotion) ?? .happy, title: data[i].title, description: data[i].description)])
                                    }
                                }
                            }
                        }
                    }
                    
                    owner.dayData.accept(allDayData)
                }
            })
            .disposed(by: bag)
    }
}
