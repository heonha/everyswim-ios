//
//  UserData.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/2/23.
//

import Foundation

final class UserData {
    
    var goal = GoalPerWeek(distancePerWeek: 1500, lapTimePerWeek: 60, countPerWeek: 3)
    
    struct Constant {
        static let goalDefaultsKey = "user_goal"
    }
    
    static let shared = UserData()
    
    private init() {
        loadGoalData()
    }
    
    private func loadGoalData() {
        let goal = UserDefaults.standard.object(forKey: Constant.goalDefaultsKey) as? Data
        guard let goal = goal else { return }
        
        do {
            let data = try JSONDecoder().decode(GoalPerWeek.self, from: goal)
            self.goal = data
        } catch {
            print(error)
        }
    }
    
    func updateGoal(distance: Int, lap: Int, countPerWeek: Int) {
        let distancePerWeek = distance * countPerWeek
        let lapPerWeek = lap * countPerWeek
        let goal = GoalPerWeek(distancePerWeek: distancePerWeek, lapTimePerWeek: lapPerWeek, countPerWeek: countPerWeek)
        self.goal = goal
    }
    
    func saveGoalData() {
        let data = try? JSONEncoder().encode(goal)
        UserDefaults.standard.setValue(data, forKey: Constant.goalDefaultsKey)
        self.loadGoalData()
    }
}
