//
//  SeachViewController.swift
//  BookShop
//
//  Created by gkang on 6/17/24.
//

import UIKit
import SnapKit
import Combine

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<SearchViewModel.Input, Never> = .init()
    
    private let topStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
    
    
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("검색", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    private let cellID = "BookDataCellID"
    
    private let listTableView = UITableView()
    
    @Published var bookData: [BookData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        interface()
    }
    
    private func setup() {
        view.backgroundColor = .green
        
        listTableView.register(SearchListCell.self, forCellReuseIdentifier: cellID)
        listTableView.delegate = self
        listTableView.dataSource = self
        
        
        let action = UIAction(handler: { _ in
            if let keyword = self.searchField.text {
                self.input.send(.KeywordInput(keyword))
            }
        })
        
        searchButton.addAction(action, for: .touchUpInside)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .SearchData(let data):
                    self?.bookData = data ?? []
                    self?.listTableView.reloadData()
                case .ErrorMessage(let message):
                    self?.showError(message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func interface() {
        view.addSubview(topStackView)
        topStackView.snp.makeConstraints { 
            $0.top.equalToSuperview().inset(Device.topInset)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        topStackView.addArrangedSubview(searchField)
        topStackView.addArrangedSubview(searchButton)

        searchField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { 
            $0.top.equalTo(topStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func showError(_ message: String) {
        print(message)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchListCell
        cell.data = bookData[indexPath.row]

        return cell
    }
}
