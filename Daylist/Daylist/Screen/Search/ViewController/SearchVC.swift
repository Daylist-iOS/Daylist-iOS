//
//  SearchVC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import RxDataSources
import SnapKit
import Then

final class SearchVC: BaseViewController {
    
    // MARK: Properties
    private var searchBar = UISearchBar().then {
        $0.showsCancelButton = true
        $0.searchBarStyle = .prominent
        $0.tintColor = .black
        $0.isTranslucent = false
        $0.becomeFirstResponder()
        $0.backgroundImage = UIImage()
    }
    
    private var searchResultTV = UITableView().then {
        $0.rowHeight = 144.adjustedH
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    private var bag = DisposeBag()
    private var viewModel = SearchVM()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Configure
    
    override func configureView() {
        super.configureView()
        configureSearchBar()
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureUI()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindLoading()
        bindOnError()
        bindDataSource()
    }
}

// MARK: - Configure

extension SearchVC {
    private func configureTableView() {
        searchResultTV.register(SearchTVC.self, forCellReuseIdentifier: SearchTVC.className)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
}

// MARK: - Layout

extension SearchVC {
    private func configureUI() {
        view.addSubviews([searchBar, searchResultTV])
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        searchResultTV.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Output

extension SearchVC {
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
        let dataSource = dataSource()
        
        viewModel.output.dataSource
            .bind(to: searchResultTV.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

// MARK: - DataSource

extension SearchVC {
    private func dataSource() -> RxTableViewSectionedReloadDataSource<DataSourceSearch> {
        let dataSource = RxTableViewSectionedReloadDataSource<DataSourceSearch> { _, tableView, indexPath, search in
            guard let searchCell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.className, for: indexPath) as? SearchTVC else { return UITableViewCell() }
            searchCell.searchResultView.setData(isData: .exist, model: CalendarSummaryModel(thumbnailImageName: search.thumbnailImage,
                                                                                            date: search.createdAt.serverTimeToString(dateFormat: "yyyy.MM.dd"),
                                                                                            emotion: EmotionType(rawValue: search.emotion) ?? .happy,
                                                                                            title: search.title,
                                                                                            description: search.description))
            return searchCell
        }
        
        return dataSource
    }
}

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    
    /// searchBarTextDidBeginEditing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let cancelBtn = searchBar.value(forKey: "cancelButton") as! UIButton
        cancelBtn.setTitle("나가기", for: .normal)
    }
    
    /// searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.postSearchData(with: SearchDataRequest(userId: 1, keyword: searchBar.searchTextField.text ?? ""))
    }
    
    /// searchBarShouldEndEditing
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        /// 키보드가 내려갈 때 endEditing 상태가 되어도 cancelBtn은 활성화되어있도록 설정
        DispatchQueue.main.async {
            if let cancelBtn = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelBtn.isEnabled = true
            }
        }
        return true
    }
}
