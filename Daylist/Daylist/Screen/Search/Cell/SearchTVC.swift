//
//  SearchTVC.swift
//  Daylist
//
//  Created by hwangJi on 2022/06/21.
//

import UIKit
import Then
import SnapKit

final class SearchTVC: UITableViewCell {
    
    // MARK: Properties
    var searchResultView = CalendarSummaryView().then {
        $0.setBackgroundColor(isHome: false)
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func layoutIfNeeded() {
        searchResultView.cdPlayerView.playerCD.layer.cornerRadius = 44
    }
}

// MARK: - UI

extension SearchTVC {
    private func configureUI() {
        addSubview(searchResultView)
        searchResultView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
