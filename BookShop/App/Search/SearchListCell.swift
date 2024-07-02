//
//  SearchListCell.swift
//  BookShop
//
//  Created by gkang on 7/1/24.
//

import UIKit
import SnapKit

class SearchListCell: BaseTableViewCell {
    private let cellContentView = ListCellContentView()
    
    var data: BookData? {
        didSet { configure() }
    }
    
    override func setup() {
        backgroundColor = .black
    }
    
    override func prepareForReuse() {
        cellContentView.data = nil
    }
    
    override func interface() {
        contentView.addSubview(cellContentView)
        cellContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configure() {
        guard let data = data else { return }
        cellContentView.data = data
    }
}
