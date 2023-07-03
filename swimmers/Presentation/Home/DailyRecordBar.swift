//
//  DailyRecordBar.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct DailyRecordBar: View {
    
    var day: WeekdayType
    var score: CGFloat
    @State var isPressed = false
    @State private var barHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(isPressed ? ThemeColor.primary : Color(hex: "000000").opacity(0.1))
                .frame(height: barHeight)
                .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 0.7),
                           value: barHeight * 0.9)

            Text(day.rawValue)
                .font(.custom(.sfProBold, size: 17))
                .foregroundColor(ThemeColor.grayTint)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                barHeight = score
            }
        }
    }
}

struct DailyRecordBar_Previews: PreviewProvider {
    static var previews: some View {
        DailyRecordBar(day: .fri, score: 50)
    }
}
