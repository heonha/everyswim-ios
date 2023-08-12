//
//  CustomDatePicker.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/07.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @State var currentDate = Date()
    var tintColor = Color.init(uiColor: UIColor.systemPink)
    let days = ["일", "월", "화", "수", "목", "금", "토"]

    // 이전/다음 버튼 클릭하면 이 변수가 사용 됨
    @State var currentMonth = 0
    
    var body: some View {
        VStack(spacing: 35) {
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.custom(.sfProLight, size: 14))
                    
                    Text(extraDate()[1])
                        .font(.custom(.sfProBold, size: 20))
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            // 요일 뷰
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 날짜 뷰
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    cardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                            print("current: \(currentDate), value: \(value.date)")
                        }
                }
            }
            
            taskList()
        }
        .onChange(of: currentMonth) { newValue in
            // 월 별 뷰 업데이트.
            print("onChange -> \(newValue)")
            currentDate = getCurrentMonth()
        }
    }
    
}

extension CustomDatePicker {
    
    private func taskList() -> some View {
        VStack {
            Text("Tasks")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            if let task = tasks.first(where: { task in
                return isSameDay(date1: task.taskDate, date2: currentDate)
            }) {
                ScrollView {
                    ForEach(task.task) {task in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(task.time
                                .addingTimeInterval(CGFloat.random(in: 0...5000)),
                                 style: .time)
                            .padding(.horizontal)

                            Text(task.title)
                                .font(.title2.bold())
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                        .background(
                            tintColor
                                .opacity(0.5)
                                .cornerRadius(10)
                        )
                        .padding(.horizontal)
                    }
                }
            } else {
                Text("Task Not Found")
            }
        }
    }
    
    private func cardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }) {
                    workCard(value, task: task)
                } else {
                    emptyCard(value)
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    private func workCard(_ value: DateValue, task: DateTaskMetaData) -> some View {
        VStack {
            Text("\(value.day)")
                .font(.title3.bold())
                .foregroundColor((isSameDay(date1: task.taskDate, date2: currentDate) ? Color.white : .primary))
                .frame(maxWidth: .infinity)

            Spacer()
            
            Circle()
                .fill(isSameDay(date1: task.taskDate, date2: currentDate) ? Color.white : tintColor)
                .frame(width: 8, height: 8)
        }
    }
    
    private func emptyCard(_ value: DateValue) -> some View {
        VStack {
            Text("\(value.day)")
                .bold()
                .frame(maxWidth: .infinity)
                .foregroundColor((isSameDay(date1: value.date, date2: currentDate) ? Color.white : .primary))
            
            Spacer()
        }
    }
    
    // 날짜 체크하기
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // 연도와 월을 추출하기.
    private func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    private func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // 기존 월 가져오기
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return Date()
        }
        
        print("Current Month: \(currentMonth)")
        
        return currentMonth
    }
    
    private func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        // 기존 월 가져오기
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return []
        }
        
        // 일자 가져오기
        var days = currentMonth
            .getAllDates()
            .compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                return DateValue(day: day, date: date)
            }
        
        // 주간 첫번째 요일 찾기.
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    
}

extension Date {
    
    /// 달력의 모든 날짜 가져오기.
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // Start Date 가져오기
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            let date = calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
            return date
        }
    }
    
}

struct CustomDatePicker_Previews: PreviewProvider {
        
    static var previews: some View {
        CustomDatePicker()
    }
}
