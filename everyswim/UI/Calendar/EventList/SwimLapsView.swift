//
//  SwimLapsView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import SwiftUI

struct SwimLapsView: View {
    
    let data: SwimMainData
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("Lap")
                        .font(.custom(.sfProMedium, size: 16))
                    
                    Text("\(data.laps.count)")
                        .font(.custom(.sfProBold, size: 20))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                }
                .frame(height: 30)
                
                ForEach(data.laps.indices, id: \.self) { index in
                    let event = data.laps[index]
                    lapCell(event)
                        .frame(height: 70)
                }
            }
        }
        .navigationTitle("\(data.startDate.toString(.dateKr))")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColor.skyBackground)
        
    }
    
    private func subSectionView(title: String, count: String) -> some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.custom(.sfProMedium, size: 16))
            
            Text(count)
                .font(.custom(.sfProBold, size: 20))
                .foregroundColor(AppColor.grayTint)
        }
    }
    
    private func lapCell(_ event: Lap) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
            
            HStack {
                Spacer()
                
                subSectionView(title: "Lap",
                               count: "\(event.index)")
                
                Divider()
                    .padding()
                
                subSectionView(title: "랩 타임",
                               count: event.dateInterval.duration.toRelativeTime(.hourMinuteSeconds))

                Divider()
                    .padding()


                subSectionView(title: "스타일", count: "\(event.style?.name ?? "")")


                Spacer()
            }
        }
    }
}

struct SwimmingEventsCell_Previews: PreviewProvider {
    static var previews: some View {
        SwimLapsView(data: TestObjects.swimmingData.first!)
    }
}
