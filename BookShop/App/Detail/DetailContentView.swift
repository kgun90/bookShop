//
//  DetailContentView.swift
//  BookShop
//
//  Created by gkang on 7/3/24.
//

import UIKit
import SnapKit
import PDFKit

class DetailContentView: BaseView {
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let imageView = UIImageView()

    private let titleLabel = BaseLabel(size: 28, textColor: .white)
    private let subtitleLabel = BaseLabel(size: 20, textColor: .lightGray)
    private let authorLabel = BaseLabel(size: 16, textColor: .white)
    private let publisherLabel = BaseLabel(size: 16, textColor: .white)
    private let languageLabel = BaseLabel(size: 16, textColor: .white)
    private let pagesLabel = BaseLabel(size: 16, textColor: .white)
    private let yearLabel = BaseLabel(size: 16, textColor: .white)
    private let ratingLabel = BaseLabel(size: 16, textColor: .white)
    private let descriptionLabel = BaseLabel(size: 16, textColor: .white)
    private let priceLabel = BaseLabel(size: 16, textColor: .white)
    
    private let pdfView = PDFView()

    var data: BookData? {
        didSet { configure() }
    }
    
    override func setup() {
        imageView.contentMode = .scaleAspectFit
        pdfView.contentMode = .scaleAspectFit
    }
    
    override func interface() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(authorLabel)
        contentStackView.addArrangedSubview(publisherLabel)
        contentStackView.addArrangedSubview(languageLabel)
        contentStackView.addArrangedSubview(pagesLabel)
        contentStackView.addArrangedSubview(yearLabel)
        contentStackView.addArrangedSubview(ratingLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(priceLabel)
      
        contentStackView.addArrangedSubview(pdfView)
        pdfView.snp.makeConstraints {
            $0.height.equalTo(400)
        }
    }
    
    private func configure() {
        guard let bookDetail = data else { return }
        
        titleLabel.text = "\(bookDetail.title)"
        subtitleLabel.text = "\(bookDetail.subtitle)"
        authorLabel.text = "\(bookDetail.authors ?? "")"
        publisherLabel.text = "Publisher: \(bookDetail.publisher ?? "")"
        languageLabel.text = "Language: \(bookDetail.language ?? "")"
        pagesLabel.text = "Pages: \(bookDetail.pages ?? "")"
        yearLabel.text = "Year: \(bookDetail.year ?? "")"
        ratingLabel.text = "Rating: \(bookDetail.rating ?? "")"
        descriptionLabel.text = "Description: \(bookDetail.desc ?? "")"
        priceLabel.text = "Price: \(bookDetail.price ?? "")"
        
        imageView.loadImage(bookDetail.image)
        
        if let pdfLinks = bookDetail.pdf, let pdfURLString = pdfLinks.values.first, let pdfURL = URL(string: pdfURLString) {
            loadPDF(from: pdfURL)
        }
    }
    
    private func loadPDF(from url: URL) {
        let document = PDFDocument(url: url)
        pdfView.document = document
    }
}
