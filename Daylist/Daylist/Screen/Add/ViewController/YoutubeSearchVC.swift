//
//  YoutubeSearchVC.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/13.
//

import UIKit
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then

class YoutubeSearchVC: BaseViewController {
    private var bag = DisposeBag()
    private var viewModel = YoutubeSearchVM()
    let naviBar = NavigationBar()
    
    private var searchTextField = UITextField()
        .then {
            $0.font = .KyoboHandwriting(size: 16)
            $0.placeholder = "검색어를 입력하세요."
        }
    
    private var searchBtn = UIButton()
        .then {
            $0.tintColor = .black
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
    
    private var separator = UIView()
        .then {
            $0.backgroundColor = .gray
        }
    
    private var searchResultTV = UITableView()
        .then {
            $0.rowHeight = 95
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureSearch()
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        layoutSearch()
        layoutTableView()
    }
    
    override func bindInput() {
        super.bindInput()
        bindTableViewItemSelected()
        bindTableViewModelSelected()
        bindSearchBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindOnError()
        bindDataSource()
    }
}

// MARK: - Configure

extension YoutubeSearchVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self, title: "검색")
        naviBar.configureBackBtn(targetVC: self, action: #selector(popVC), naviType: .push)
    }
    
    private func configureSearch() {
        view.addSubview(searchTextField)
        view.addSubview(searchBtn)
        view.addSubview(separator)
    }
    
    private func configureTableView() {
        view.addSubview(searchResultTV)
        searchResultTV.register(YoutubeSearchTVC.self,
                                forCellReuseIdentifier: YoutubeSearchTVC.className)
        searchResultTV.contentInset.top = 4
        searchResultTV.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - Layout

extension YoutubeSearchVC {
    private func layoutSearch() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(36)
        }
        
        searchBtn.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField.snp.centerY)
            $0.width.height.equalTo(24)
            $0.leading.equalTo(searchTextField.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
    }

    private func layoutTableView() {
        searchResultTV.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension YoutubeSearchVC {
    private func bindTableViewItemSelected() {
        searchResultTV.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.searchResultTV.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
    
    private func bindTableViewModelSelected() {
        searchResultTV.rx.modelSelected(YoutubeItemResponse.self)
            .bind(onNext: { [weak self] media in
                guard let self = self else { return }
                // TODO: - AddVC 데이터 연결
                print(media.snippet.title)
                print("https://www.youtube.com/watch?v=\(media.id.videoId)")
                print(URL(string: media.snippet.thumbnails.default?.url ?? "")!)
                self.popVC()
            })
            .disposed(by: bag)
    }
    
    private func bindSearchBtn() {
        searchBtn.rx.tap
            .bind(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.viewModel.fetchAll()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension YoutubeSearchVC {
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

extension YoutubeSearchVC {
    private func dataSource() -> RxTableViewSectionedReloadDataSource<DataSourceMedia> {
        let dataSource = RxTableViewSectionedReloadDataSource<DataSourceMedia> { _, tableView, indexPath, article in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YoutubeSearchTVC.className, for: indexPath) as? YoutubeSearchTVC else {
                return UITableViewCell()
            }
            cell.configureCell(with: article, with: CGSize(width: 95, height: 95))
            
            return cell
        }
        
        return dataSource
    }
}
