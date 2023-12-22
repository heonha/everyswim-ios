//
//  UseCancellables.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import Combine

protocol UseCancellables {
    var cancellables: Set<AnyCancellable> { get set }
}
