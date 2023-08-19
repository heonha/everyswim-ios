//
//  EventListCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/19/23.
//

import SwiftUI

struct EventListCell: View {
    
    let data: SwimMainData
    
    var body: some View {
        NavigationLink {
            SwimDetailView(data: data)
        } label: {
            mainBody
        }
    }
    
    var mainBody: some View {
        ZStack {
            CellBackground(cornerRadius: 12,
                           shadowRadius: 1.2,
                           shadowOpacity: 0.12,
                           shadowLocation: CGPoint(x: 0.2, y: 0.2))
            cellBody
        }
        .frame(height: 65)
        .padding(2)
    }
    
    var cellBody: some View {
        HStack {
            dayView
                    
            Divider()
                .padding()
            
            contentView
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColor.grayTint)
        }
        .padding(.horizontal, 24)
    }
    
    private var dayView: some View {
        VStack(spacing: 4) {
            Text(data.getDayDotMonth())
                .font(.custom(.sfProMedium, size: 16))
                .foregroundColor(AppColor.primaryBlue)
            
            Text(data.getWeekDay())
                .font(.custom(.sfProLight, size: 12))
                .foregroundColor(AppColor.primaryBlue)
        }
    }
    
    private var contentView: some View {
        let records = data.getSimpleRecords()
        
        return VStack(alignment: .leading, spacing: 4) {
            Text("\(data.getWeekDay()) 수영")
                .font(.custom(.sfProMedium, size: 16))
                .foregroundColor(Color.black)
            
            Text("\(records.duration) | \(records.distance)m | \(records.lap) Lap")
                .font(.custom(.sfProLight, size: 14))
                .foregroundColor(AppColor.primaryBlue)
        }
    }
    
}

#Preview {
    EventDatePickerContainer()
    // EventListCell(data: TestObjects.swimmingData.first!)
}
