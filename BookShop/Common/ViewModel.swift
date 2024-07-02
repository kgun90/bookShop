//
//  ViewModel.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation
import Combine

protocol ViewModel {
    associatedtype Input
    associatedtype State
    typealias Output = AnyPublisher<State, Never>
    
    func transform(input: Input) -> Output
}

