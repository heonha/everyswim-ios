//
//  SetGoalViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/2/23.
//

import Foundation

final class SetGoalViewModel {
    
    // Data
    private var userData = UserData.shared
    var distance: Int = 0
    var lap: Int = 0
    var count: Int = 0
    
    // Cells
    let cellIndex = 0
    let cellCount = 3
    
    init() {
        setData()
    }
    
    private func setData() {
        let goal = userData.goal
        self.count = goal.countPerWeek
        self.distance = goal.distancePerWeek / count
        self.lap = goal.lapTimePerWeek / count
    }
    
    func getTitles(_ type: MyGoalType) -> SetGoalText {
        switch type {
        case .distance:
            return SetGoalText(title: "거리", subtitle: "하루에 수영 할 목표 거리를 선택해주세요", unit: "미터 / 일")
        case .lap:
            return SetGoalText(title: "Lap", subtitle: "하루에 레인을 몇 번 횡단 할지 설정해 주세요", unit: "Lap / 일")
        case .swimCount:
            return SetGoalText(title: "주간 수영 횟수", subtitle: "일주일에 몇 일을 수영 할 예정이신가요?", unit: "Lap / 일")
        }
    }
    
    func saveGoal() {
        let distancePerWeek = distance * count
        let lapTimePerWeek = lap * count
        let countPerWeek = count
        userData.goal = .init(distancePerWeek: distancePerWeek, lapTimePerWeek: lapTimePerWeek, countPerWeek: countPerWeek)
        userData.saveGoalData()
    }
    
    func getCurrentData() -> GoalPerWeek {
        return userData.goal
    }
    
}
