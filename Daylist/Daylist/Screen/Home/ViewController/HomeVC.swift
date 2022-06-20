//
//  HomeVC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/18.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

final class HomeVC: BaseViewController {
    
    // MARK: Properties
    
    private let searchBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_search"), for: .normal)
    }
    
    private let settingBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_settings"), for: .normal)
    }
    
    private let goToLastMonthBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_before_touch"), for: .normal)
    }
    
    private let goToNextMonthBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_after_touch"), for: .normal)
    }
    
    private let headerLabel = UILabel().then {
        $0.textColor = .headerGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    private let calendarCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 11
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    private let detailView = CalendarSummaryView().then {
        $0.setBackgroundColor(isHome: true)
    }
    
    private let addBtn = UIButton().then {
        $0.setImage(UIImage(named: "btn_add"), for: .normal)
    }
    
    private var bag = DisposeBag()
    private var viewModel = HomeVM()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doAfterCalculate(calType: .current)
    }
    
    // MARK: Configure
    
    override func configureView() {
        super.configureView()
        configureCollectionView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureUI()
    }
    
    override func bindInput() {
        super.bindInput()
        bindUserInteractions()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindLoading()
        bindOnError()
        bindDataSource()
    }
}

// MARK: - Configure

extension HomeVC {
    private func configureCollectionView() {
        calendarCV.delegate = self
        calendarCV.dataSource = self
        calendarCV.register(WeekCVC.self, forCellWithReuseIdentifier: WeekCVC.className)
        calendarCV.register(DayCVC.self, forCellWithReuseIdentifier: DayCVC.className)
    }
}

// MARK: - Layout

extension HomeVC {
    private func configureUI() {
        view.addSubviews([searchBtn, settingBtn, goToLastMonthBtn, goToNextMonthBtn, headerLabel, calendarCV, detailView, addBtn])
        
        settingBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().inset(15)
            $0.width.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 24))
        }
        
        searchBtn.snp.makeConstraints {
            $0.trailing.equalTo(settingBtn.snp.leading).offset(-15)
            $0.width.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 19))
            $0.centerY.equalTo(settingBtn)
        }
        
        goToLastMonthBtn.snp.makeConstraints {
            $0.top.equalTo(settingBtn.snp.bottom).offset(36)
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 43))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 43) * 25 / 43)
        }
        
        goToNextMonthBtn.snp.makeConstraints {
            $0.centerY.width.height.equalTo(goToLastMonthBtn)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(settingBtn.snp.bottom).offset(13)
            $0.leading.equalTo(goToLastMonthBtn.snp.trailing).offset(39)
            $0.trailing.equalTo(goToNextMonthBtn.snp.leading).inset(-39)
        }
        
        calendarCV.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.bottom.equalTo(detailView.snp.top).inset(-16)
        }
        
        detailView.snp.makeConstraints {
            $0.bottom.equalTo(addBtn.snp.top).offset(-21)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 134.adjustedH))
        }
        
        addBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.trailing.equalToSuperview().inset(19)
            $0.height.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 44))
        }
    }
}

// MARK: - Custom Methods

extension HomeVC {
    
    /** - Description:캘린더 계산 이후에 동작되는 작업을 묶은 메서드
     1. 계산
     2. 계산된 년/월로 서버 통신
     3. 캘린더 헤더 Label Text 변경
     */
    private func doAfterCalculate(calType: CalendarCalculateType) {
        let calculate = viewModel.calculation(type: calType)
        viewModel.getCalendarData(with: CalendarRequestModel(userId: 1, year: String(describing: calculate[0]), month: String(describing: calculate[1])))
        headerLabel.attributedText = viewModel.setUpHeaderString()
    }
}

// MARK: - Input

extension HomeVC {
    private func bindUserInteractions() {
        goToLastMonthBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.doAfterCalculate(calType: .last)
            })
            .disposed(by: bag)
        
        goToNextMonthBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.doAfterCalculate(calType: .next)
            })
            .disposed(by: bag)
        
        searchBtn.rx.tap
            .subscribe(onNext: {
                let searchVC = SearchVC()
                self.navigationController?.pushViewController(searchVC, animated: true)
            })
            .disposed(by: bag)
        
        settingBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let settingVC = SettingNC()
                settingVC.modalPresentationStyle = .fullScreen
                self?.present(settingVC, animated: true)
            })
            .disposed(by: bag)
        
        addBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let addVC = AddNC()
                addVC.modalPresentationStyle = .fullScreen
                self?.present(addVC, animated: true)
            })
            .disposed(by: bag)
        
        calendarCV.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.detailView.setData(
                    isData: self.viewModel.dayData.value[indexPath.row].playlistID == 0 ? .none : .exist,
                    model: CalendarSummaryModel(
                        thumbnailImageName: self.viewModel.dayData.value[indexPath.row].thumbnailImage,
                        date: self.viewModel.dayData.value[indexPath.row].createdAt.serverTimeToString(dateFormat: "yyyy.MM.dd"),
                        emotion: EmotionType(rawValue: self.viewModel.dayData.value[indexPath.row].emotion) ?? .happy,
                        title: self.viewModel.dayData.value[indexPath.row].title,
                        description: self.viewModel.dayData.value[indexPath.row].description))
            })
            .disposed(by: bag)
        
        detailView.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { _ in
                // TODO: 상세뷰와 연결
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension HomeVC {
    private func bindLoading() {
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                self.loading(loading: loading)
            })
            .disposed(by: bag)
    }
    
    private func bindOnError() {
        viewModel.output.onError
            .asDriver(onErrorJustReturn: .unknown)
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.description)
            })
            .disposed(by: bag)
    }
    
    private func bindDataSource() {
        viewModel.dayData
            .subscribe(onNext: { [weak self] _ in
                self?.calendarCV.reloadData()
            }).disposed(by: bag)
        
        viewModel.summaryData
            .subscribe(onNext: { [weak self] data in
                if data.count != 0 {
                    self?.detailView.setData(isData: .today, model: data[0])
                }
            }).disposed(by: bag)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    
    /// numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 7
        default:
            return viewModel.dayData.value.count
        }
    }
    
    /// cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weekCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCVC.className, for: indexPath) as? WeekCVC,
              let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCVC.className, for: indexPath) as? DayCVC else { return UICollectionViewCell() }
        
        if indexPath.row % 7 == 0 { // 일요일
            [dayCell.dayLabel, weekCell.weekLabel].forEach {
                $0?.textColor = .red
            }
        } else if indexPath.row % 7 == 6 { // 토요일
            [dayCell.dayLabel, weekCell.weekLabel].forEach {
                $0?.textColor = .blue
            }
        } else { // 평일
            weekCell.weekLabel.textColor = .darkGray
            dayCell.dayLabel.textColor = .black
        }
        
        switch indexPath.section {
        case 0:
            weekCell.setData(weekString: viewModel.weeks[indexPath.row])
            return weekCell
        default:
            dayCell.setData(model: viewModel.dayData.value[indexPath.row], dayString: viewModel.days[indexPath.row])
            return dayCell
        }
    }
}


// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 38.adjusted, height: 18.adjustedH)
        default:
            return CGSize(width: 38.adjusted, height: 60.adjustedH)
        }
    }
    
    /// minimumLineSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    /// minimumInteritemSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 7.adjusted
        default:
            return 7.adjusted
        }
    }
    
    /// insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
    }
}
