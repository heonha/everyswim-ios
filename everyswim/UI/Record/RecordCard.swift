//
//  RecordCard.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/17/24.
//

import SwiftUI

struct RecordCard: View {
    
    let record: SwimMainData
 
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.init(uiColor: .init(hex: "191C21")))
            
            HStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.clear)
                    VStack {
                        Text(record.startDate.toString(.dateKrShort))
                            .font(.custom(.sfProBold, size: 14))
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(record.distanceString)
                                .font(.custom(.sfProBold, size: 32))

                            Text("Meters")
                                .font(.custom(.sfProBold, size: 14))
                                .foregroundStyle(Color.secondary)

                        }
                        
                        Spacer()
                    }
                }
                .frame(width: AppConstant.deviceSize.width / 3)
                
                Spacer()
                
                rightRecordStack()
                
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 14)
        }
        .frame(height: 120)

    }
    
}

extension RecordCard {
    
    private func rightRecordStack() -> some View {
        HStack {
            Spacer()

            VStack {
                recordVStack(title: "시간", value: record.durationString2)
                recordVStack(title: "랩", value: record.lapCount)
            }
            
            Spacer()
            
            VStack {
                recordVStack(title: "페이스", value: "0’00’’") // TODO: 랩타임 추가할 것
                recordVStack(title: "칼로리", value: record.totalKcalString)
            }
            
            Spacer()

        }
        .frame(width: .infinity)
    }
        
    private func recordVStack(title: String, value: String) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.clear)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.custom(.sfProBold, size: 14))
                
                Text(value)
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundStyle(AppColor.labelTint)
            }
        }
    }

}

#Preview {
    RecordCard(record: SwimMainData.default)
        .padding(.horizontal)
}
