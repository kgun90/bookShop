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
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentKeyword = CurrentValueSubject<String, Never>("")
    private var currentPage = CurrentValueSubject<Int, Never>(1)
    private var totalPages = CurrentValueSubject<Int, Never>(1)
    private var isLoading = CurrentValueSubject<Bool, Never>(false)
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .KeywordInput(let keyword):
                self?.currentKeyword.send(keyword)
                self?.currentPage.send(1)
                
                self?.output.send(.SearchData([]))
                
                self?.searchAction(keyword)
                
            case .LoadMore:
                self?.loadMoreAction()
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func loadMoreAction() {
        guard currentPage.value < totalPages.value && !isLoading.value else { return }
        currentPage.send(currentPage.value + 1)
        searchAction(currentKeyword.value)
    }
    
    private func searchAction(_ keyword: String) {
        guard !isLoading.value else { return }
        isLoading.send(true)
        
        SearchRepository.shared.getSearchResult(keyword: keyword, page: currentPage.value) { response in
            self.isLoading.send(false)
            switch response {
            case let model as SearchResponse:
                self.totalPages.send((Int(model.total) ?? 1) / 10)
                self.output.send(.SearchData(model.books))
                
            case let error as ErrorResponse:
                self.output.send(.ErrorMessage(error.message))
            default:
                print("Response Error")
            }
        }
    }
}

