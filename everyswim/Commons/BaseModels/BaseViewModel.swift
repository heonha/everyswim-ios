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
    var isPresentMessage = CurrentValueSubject<Bool, Never>(false)
    var presentMessage = CurrentValueSubject<String, Never>("")
    
    func sendMessage(message: String) {
        self.presentMessage.send(message)
        self.isPresentMessage.send(true)
    }
}
