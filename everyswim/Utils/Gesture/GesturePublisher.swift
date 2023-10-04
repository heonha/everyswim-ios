//
//  GesturePublisher.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit
import Combine

struct GesturePublisher: Publisher {
    
    typealias Output = GestureType
    typealias Failure = Never
    
    private let view: UIView
    private let type: GestureType
    
    init(view: UIView, type: GestureType) {
        self.view = view
        self.type = type
    }
    
    func receive<S>(subscriber: S) where S: Subscriber,
                                            GesturePublisher.Failure == S.Failure,
                                            GesturePublisher.Output == S.Input {
        let subscription = GestureSubscription(subscriber: subscriber,
                                               view: view,
                                               type: type)
        subscriber.receive(subscription: subscription)
    }
    
}
