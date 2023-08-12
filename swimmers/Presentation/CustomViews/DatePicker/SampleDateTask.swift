//
//  SampleDateTask.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import SwiftUI

// Task
struct DateTask: Identifiable {
    let id = UUID().uuidString
    let title: String
    let time = Date()
}

// 모든 Task
struct DateTaskMetaData: Identifiable {
    let id = UUID().uuidString
    let task: [DateTask]
    let taskDate: Date
}

// 샘플 데이트 테스팅
func getSampleDate(offset: Int) -> Date {
    let calender = Calendar.current
    
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [DateTaskMetaData] = [

    DateTaskMetaData(task: [
        DateTask(title: "입사"),
        DateTask(title: "맥북 받기"),
        DateTask(title: "개발 규칙 이해하기")
    ], taskDate: getSampleDate(offset: 0)),
    DateTaskMetaData(task: [
        DateTask(title: "task1")
    ], taskDate: getSampleDate(offset: -3)),
    DateTaskMetaData(task: [
        DateTask(title: "팀쿡 만나기")
    ], taskDate: getSampleDate(offset: -7)),
    DateTaskMetaData(task: [
        DateTask(title: "마지막 출근")
    ], taskDate: getSampleDate(offset: -9))
    
]
