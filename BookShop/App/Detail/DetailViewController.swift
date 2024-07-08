//
//  DetailViewController.swift
//  BookShop
//
//  Created by gkang on 7/3/24.
//

import UIKit
import SnapKit
import Combine

protocol DetailViewDelegate {
    func modalDismiss()
}

class DetailViewController: UIViewController {
    init(isbn13: String) {
        self.isbn13 = isbn13
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var delegate: DetailViewDelegate?
    private let isbn13: String
    private let viewModel = DetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        
        return sv
    }()
    
    private lazy var closeButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("닫기", for: .normal)
        btn.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        return btn
    }()
    
    private let favoriteButton = UIButton()
    private let spacer = UIView()
    private let ratingButton = UIButton()
    
    private let contentScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceHorizontal = false
        return sv
    }()
    
    private let contentView = DetailContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        interface()
    }
    
    private func setup() {
        view.backgroundColor = .black
        setupTopView()
    }
 
    private func bind() {
        let input = Just(DetailViewModel.Input.isbn13(isbn13)).eraseToAnyPublisher()
        let output = viewModel.transform(input: input)
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loaded(let data):
                    self?.contentView.data = data
                case .ErrorMessage(let message):
                    self?.showAlert(title: "Error", message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func interface() {
        view.addSubview(topStackView)
        topStackView.snp.makeConstraints { 
            $0.height.equalTo(30)
            $0.top.equalToSuperview().inset(Device.topInset)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        topStackView.addArrangedSubview(closeButton)
        topStackView.addArrangedSubview(spacer)
        topStackView.addArrangedSubview(favoriteButton)
        topStackView.addArrangedSubview(ratingButton)
        
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        contentScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    private func showAlert(title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    private func setupTopView() {
        favoriteButton.addTarget(self, action: #selector(actionFavorite), for: .touchUpInside)
        setFavoriteButton()
        
        ratingButton.addTarget(self, action: #selector(actionRating), for: .touchUpInside)
        setRatingButton()
    }
    
    private func setFavoriteButton() {
        let favorite = BookManager.shared.getFavorite(isbn13: isbn13)
        let favoriteImage = favorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        favoriteButton.setImage(favoriteImage, for: .normal)
        favoriteButton.tintColor = favorite ? .red : .systemGray
    }
    
    @objc
    private func actionFavorite() {
        let before = BookManager.shared.getFavorite(isbn13: self.isbn13)
        BookManager.shared.setFavorite(isbn13: isbn13)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            if before != BookManager.shared.getFavorite(isbn13: self.isbn13) {
                let message = before ? "에서 삭제" : "에 추가"
                self.showAlert(title: "Alert", "즐겨찾기\(message) 되었습니다.")
                self.setFavoriteButton()
            }
        }
    }
    
    @objc
    private func actionClose() {
        delegate?.modalDismiss()
        dismiss(animated: true)
    }
    
    private func setRatingButton() {
        let rating = BookManager.shared.getRating(isbn13: isbn13)
        let star = String(repeating: "⭐️", count: rating ?? 0)
        let ratingTitle = rating == nil ? "평가하기" : star
        ratingButton.setTitle(ratingTitle, for: .normal)
        ratingButton.titleLabel?.textAlignment = .right
    }
    
    @objc
    private func actionRating() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for i in 1...5 {
            let stars = -(i - 6)
            let title = String(repeating: "⭐️", count: stars)
            let action = UIAlertAction(title: title, style: .default) { _ in
                self.alertRating(stars)
            }
            actionSheet.addAction(action)
        }
        
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        actionSheet.addAction(closeAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func alertRating(_ rate: Int) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.showAlert(title: "Alert", "평가가 완료 되었습니다.")
            BookManager.shared.setRating(isbn13: self.isbn13, rate: rate)
            self.setRatingButton()
            
        }
    }
}
