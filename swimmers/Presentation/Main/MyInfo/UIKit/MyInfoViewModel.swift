//
//  MyInfoViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import Combine

final class MyInfoViewModel: BaseViewModel {
    
    private var swimExp: Int = 1
    
    func getSwimExperience() -> Int {
        return swimExp
    }
    
    func getButtonListData() -> [MyInfoButtonType] {
        return MyInfoButtonType.allCases
    }
    
    func pushView() {
        
    }
    
}
