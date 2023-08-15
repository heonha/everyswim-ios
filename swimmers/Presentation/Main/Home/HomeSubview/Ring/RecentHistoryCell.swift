//
//  RecentHistoryCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct RecentHistoryCell: View {
    
    let destination: AnyView
    @Binding var lastWorkout: SwimMainData?
    
    init(destination: AnyView, lastWorkout: Binding<SwimMainData?>) {
        self.destination = destination
        self._lastWorkout = lastWorkout
    }
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            ZStack {
                if let lastWorkout = lastWorkout {
                    HStack(spacing: 8) {
                        Text("최근기록")
                            .font(.custom(.sfProLight, size: 12))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                            .padding(.leading)
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Text("\(lastWorkout.unwrappedDistance.toString()) m")
                                .font(.custom(.sfProBold, size: 22))
                                .foregroundColor(.init(uiColor: .label))
                                .lineLimit(1)
                            
                            Text("\(lastWorkout.laps.count) Lap")
                                .font(.custom(.sfProBold, size: 20))
                                .foregroundColor(.init(uiColor: .secondaryLabel))
                                .lineLimit(1)
                        }

                        Spacer()
                        
                        Text("\(Date.relativeDate(from: lastWorkout.startDate))")
                            .font(.custom(.sfProLight, size: 12))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                        
                        Image(systemName: "chevron.right")
                            .font(.custom(.sfProBold, size: 14))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                            .padding(.trailing)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.clear)
                        .overlay {
                            Text("운동 기록이 없습니다.")
                        }
                }
            }
            .frame(height: 48)
            .background(CellBackground(cornerRadius: 16))
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
