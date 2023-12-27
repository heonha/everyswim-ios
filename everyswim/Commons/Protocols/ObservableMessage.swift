//
//  ObservableMessage.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/25/23.
//

import Foundation
import Combine

/// 하단 메시지를 띄울 때 준수하는 프로토콜입니다. (BaseViewController 상속 필요)
protocol ObservableMessage: BaseViewController {
    
    func bindMessage()
    func presentMessage(title: String)
    
}
