//
//  SearchListCell.swift
//  BookShop
//
//  Created by gkang on 7/1/24.
//

import UIKit
import SnapKit

class ListCellContentView: BaseView {
    private lazy var bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    private let titleLabel = BaseLabel(textColor: .lightGray)
    private let subTitleLabel = BaseLabel(textColor: .lightGray)
    private let isbnLabel = BaseLabel(textColor: .lightGray)
    
    private lazy var priceLabel = BaseLabel(textColor: .lightGray)
    
    
    var data: BookData? {
        didSet { configure() }
    }
    
    override func setup() {
        backgroundColor = .black
    }
    
    override func interface() {
        addSubview(bookImageView)
        bookImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(30)
        }
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(bookImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subTitleLabel)
        contentStackView.addArrangedSubview(isbnLabel)
        contentStackView.addArrangedSubview(priceLabel)
    }
    
    private func configure() {
        guard let data = data, let imageURL = data.image, let url = URL(string: imageURL) else {
            return
        }
        
        bookImageView.load(url: url)
        titleLabel.text = data.title
        subTitleLabel.text = data.subtitle
        isbnLabel.text = data.isbn13
        priceLabel.text = data.price
    }
}

