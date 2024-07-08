//
//  SearchListCell.swift
//  BookShop
//
//  Created by gkang on 7/1/24.
//

import UIKit
import SnapKit

class ListCellContentView: BaseView {
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 5
        return sv
    }()
    
    private let titleLabel = BaseLabel(textColor: .lightGray)
    private let subTitleLabel = BaseLabel(textColor: .lightGray)
    private let isbnLabel = BaseLabel(textColor: .lightGray)
    private lazy var priceLabel = BaseLabel(textColor: .lightGray)
    
    private let extraStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        return sv
    }()
    
    private let favoriteImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let ratingLabel = BaseLabel(size: 8)
    
    
    var data: BookData? {
        didSet { configure() }
    }
    
    override func setup() {
        backgroundColor = .black
    }
    
    override func interface() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(bookImageView)
        bookImageView.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        mainStackView.addArrangedSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subTitleLabel)
        contentStackView.addArrangedSubview(isbnLabel)
        contentStackView.addArrangedSubview(priceLabel)
        contentStackView.addArrangedSubview(ratingLabel)
        
        mainStackView.addArrangedSubview(extraStackView)
        extraStackView.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        
        extraStackView.addArrangedSubview(favoriteImageView)
    }
    
    private func configure() {
        guard let data = data else {
            return
        }
        
        bookImageView.loadImage(data.image)
        titleLabel.text = data.title
        subTitleLabel.text = data.subtitle
        isbnLabel.text = data.isbn13
        priceLabel.text = data.price
        
        setExtraInfo(data.isbn13)
    }
    
    private func setExtraInfo(_ isbn13: String) {
        favoriteImageView.image = BookManager.shared.getFavorite(isbn13: isbn13) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteImageView.tintColor = BookManager.shared.getFavorite(isbn13: isbn13) ? .red : .systemGray
        
        let rating = BookManager.shared.getRating(isbn13: isbn13)
        let star = String(repeating: "⭐️", count: rating ?? 0)
    
        ratingLabel.text = star
    }
}
