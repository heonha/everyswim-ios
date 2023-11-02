//
//  UserData.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/2/23.
//

import Foundation

final class UserData {
    
    var goal = GoalPerWeek(distancePerWeek: 1500, lapTimePerWeek: 60, countPerWeek: 3)
    
    static let shared = UserData()
    
    private init() {
        
    }
    
    func updateGoal(distance: Int, lap: Int, countPerWeek: Int) {
        let distancePerWeek = distance * countPerWeek
        let lapPerWeek = lap * countPerWeek
        let goal = GoalPerWeek(distancePerWeek: distancePerWeek, lapTimePerWeek: lapPerWeek, countPerWeek: countPerWeek)
        self.goal = goal
    }
}
