//
//  SearchViewModel.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation
import Combine

class SearchViewModel {
    enum Input {
        case KeywordInput(String)
        case LoadMore
    }
    
    enum Output {
        case SearchData([BookData]?)
        case ErrorMessage(String)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentKeyword: String = ""
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoading = false
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .KeywordInput(let keyword):
                self?.currentKeyword = keyword
                self?.currentPage = 1
                self?.searchAction(keyword)
            case .LoadMore:
                self?.loadMoreAction()
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func loadMoreAction() {
        guard currentPage < totalPages && !isLoading else { return }
        currentPage += 1
        searchAction(currentKeyword)
    }
    
    private func searchAction(_ keyword: String) {
        guard !isLoading else { return }
        isLoading = true
        
        SearchRepository.shared.getSearchResult(keyword: keyword, page: currentPage) { response in
            self.isLoading = false
            switch response {
            case let model as SearchResponse:
                self.totalPages = (Int(model.total) ?? 1) / 10
                self.output.send(.SearchData(model.books))
            case let error as ErrorResponse:
                self.output.send(.ErrorMessage(error.message))
            default:
                print("Response Error")
            }
        }
    }
}

