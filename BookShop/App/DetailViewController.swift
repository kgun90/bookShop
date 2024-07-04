//
//  DetailViewController.swift
//  BookShop
//
//  Created by gkang on 7/3/24.
//

import UIKit
import SnapKit
import Combine

class DetailViewController: UIViewController {
    init(isbn13: String) {
        self.isbn13 = isbn13
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let isbn13: String
    private let viewModel = DetailViewModel()
    private var cancellables = Set<AnyCancellable>()
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
                    self?.showError(message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func interface() {
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        contentScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
