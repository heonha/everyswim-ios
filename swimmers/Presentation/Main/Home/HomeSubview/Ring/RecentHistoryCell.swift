//
//  RecentHistoryCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct RecentHistoryCell: View {
    
    let destination: AnyView
    @Binding var lastWorkout: SwimmingData?
    
    init(destination: AnyView, lastWorkout: Binding<SwimmingData?>) {
        self.destination = destination
        self._lastWorkout = lastWorkout
    }
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            ZStack {
                if let lastWorkout = lastWorkout {
                    HStack(spacing: 30) {
                        Text("\(lastWorkout.unwrappedDistance.toString()) M")
                            .font(.custom(.sfProBold, size: 24))
                            .foregroundColor(.init(uiColor: .label))
                        
                        Text("\(0) Lap")
                            .font(.custom(.sfProBold, size: 21))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text("\(Date.relativeDate(from: lastWorkout.startDate))")
                            .font(.custom(.sfProLight, size: 12))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                        
                        Image(systemName: "chevron.right")
                            .font(.custom(.sfProBold, size: 14))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 4)
                    }
                } else {
                    Text("운동 기록이 없습니다.")
                }
            }
            .background(CellBackground(cornerRadius: 16))
            .frame(height: 48)
        }
    }
    
}


extension View {
    
    func placeholderView(isOn: Bool) -> some View {
            self.overlay {
                if isOn {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.2))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .hidden()
                }
            }
    }
    
}
