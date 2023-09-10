//
//  RecordCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/05.
//

import SwiftUI

struct RecordCell: View {
    
    private let data: SwimMainData
    
    init(data: SwimMainData) {
        self.data = data
    }
    
    var body: some View {
        ZStack {
            
            Color.white
                .shadow(color: .black.opacity(0.12), radius: 1, x: 0.5, y: 0.5)
            
            Group {
                VStack(spacing: 8) {
                    HStack {
                        profileStack()
                            .frame(minHeight: 30)
                        
                        Spacer()
                        
                        recordTitle(date: data.date, time: data.durationTime)
                            .frame(minHeight: 30)
                    }
                    
                    Spacer()

                    recordStack
                        .frame(minHeight: 32)
                }
                
            }
            .padding()
        }
    }
    
    private func rightChevronSymbol() -> some View {
        Image("chevron.right")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.init(uiColor: .secondaryLabel))
            .frame(width: 14, height: 14)
            .padding(.trailing)
    }
    
    private func recordTitle(date: String, time: String) -> some View {
        HStack {
            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(date)
                    .font(.custom(.sfProMedium, size: 18))
                    .foregroundColor(.init(uiColor: .label))
                
                Text("\(data.durationString) (\(time))")
                    .font(.custom(.sfProMedium, size: 14))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                
                relativeTime()
            }

        }
    }
    
    private func recordView(title: String, titleSize: CGFloat = 20, unit: String = "") -> some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(.custom(.sfProBold, size: titleSize))
                .foregroundColor(.init(uiColor: .label))

            Text(unit)
                .font(.custom(.sfProBold, size: 16))
                .foregroundColor(.init(uiColor: .secondaryLabel))
            
        }
    }
    
    private var recordStack: some View {
        HStack {
            recordView(title: data.unwrappedDistance.toString(), unit: "m")
                .frame(maxWidth: 90)

            Divider()
            
            recordView(title: data.totalKcal.toString(), unit: "kcal")
                .frame(maxWidth: 150)

            Divider()

            recordView(title: "\(data.laps.count)", unit: "Lap")
                .frame(maxWidth: 90)
        }
    }
        
    private func profileStack() -> some View {
        VStack(spacing: 4) {
            Image("Avatar")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
                Text("Heon Ha")
                    .font(.custom(.sfProBold, size: 15))
                    .foregroundColor(.init(uiColor: .label))
                
                // locationLabel()
        }
    }
    
    private func relativeTime() -> some View {
        HStack(spacing: 2) {
            Text(Date.relativeDate(from: data.startDate))
                .font(.custom(.sfProLight, size: 14))
                .foregroundColor(.init(uiColor: .secondaryLabel))
        }
    }
    
    private func locationLabel() -> some View {
        HStack(spacing: 2) {
            Image(systemName: "location.fill")
                .font(.system(size: 12))
                .foregroundColor(.init(uiColor: .secondaryLabel))
            
            Text("서울특별시")
                .font(.custom(.sfProLight, size: 12))
                .foregroundColor(.init(uiColor: .secondaryLabel))
        }
    }
}

#if DEBUG
struct SwimmingRecordCell_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach(TestObjects.swimmingData) { data in
                    RecordCell(data: data)
                        .padding(.horizontal, 21)
                }
            }
        }
    }
}
#endif
