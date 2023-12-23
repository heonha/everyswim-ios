//
//  MessagePresentable.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import Foundation

/// ViewController에서 하단 Message 상태변화를 감지할 때 사용합니다.
protocol MessageObservable: BaseViewController {
    
    /// BaseViewModel을 준수하는 viewModel의 메시지 이벤트를 관찰합니다.
    func observeMessage<T: BaseViewModel>(viewModel: T)
    
}
