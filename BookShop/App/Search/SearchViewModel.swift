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
    }
    
    enum Output {
        case SearchData([BookData]?)
        case ErrorMessage(String)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .KeywordInput(let text):
                self?.searchAction(text)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func searchAction(_ keyword: String) {
        SearchRepository.shared.getSearchResult(keyword: keyword) { response in
            switch response {
            case let model as SearchResponse:
                self.output.send(.SearchData(model.books))
            case let error as ErrorResponse:
                self.output.send(.ErrorMessage(error.message))
            default:
                print("Response Error")
            }
        }
    }
}

