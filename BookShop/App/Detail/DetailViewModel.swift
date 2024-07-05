//
//  DetailViewModel.swift
//  BookShop
//
//  Created by gkang on 7/3/24.
//

import Foundation
import Combine

class DetailViewModel {
    enum Input {
        case isbn13(String)
    }
    
    enum Output {
        case loaded(BookData)
        case ErrorMessage(String)
    }

    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .isbn13(let isbn13): self?.fetchBookDetail(isbn13)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchBookDetail(_ isbn13: String) {
        SearchRepository.shared.getBookDetail(isbn13: isbn13) {  response in
            switch response {
            case let model as BookData:
                self.output.send(.loaded(model))
            case let error as ErrorResponse:
                self.output.send(.ErrorMessage(error.message))
            default:
                print("Response Error")
            }
        }
    }
}
