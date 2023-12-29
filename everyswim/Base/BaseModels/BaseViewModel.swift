//
//  BaseViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import Foundation
import Combine

class BaseViewModel {
    
    /// 비동기 Task 사용 시 사용
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var cancellables = Set<AnyCancellable>()
    
    /// 하단 메시지 이벤트
    private var isPresentMessageSubject = PassthroughSubject<Void, Never>()
    private var presentMessageSubject = PassthroughSubject<String, Never>()
    lazy var isPresentMessagePublisher: AnyPublisher<String, Never> = {
        return Publishers
            .CombineLatest(isPresentMessageSubject.eraseToAnyPublisher(),
                           presentMessageSubject.eraseToAnyPublisher())
            .filter { _, messageString in
                !messageString.isEmpty
            }
            .map { return $1 }
            .eraseToAnyPublisher()
    }()
    
    
    func sendMessage(message: String) {
        self.presentMessageSubject.send(message)
        self.isPresentMessageSubject.send()
    }

}
