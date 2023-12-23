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
    
}
