//
//  IOProtocol.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/29/23.
//

import Foundation
import Combine

protocol IOProtocol {
    
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set }
    
    func transform(input: Input) -> Output
    
}
