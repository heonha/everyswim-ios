//
//  SwimmingDetailView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/24.
//

import SwiftUI

struct SwimmingDetailView: View {
    
    let data: SwimmingData
    
}

extension SwimmingDetailView {
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                     .fill(.background)
                
                VStack(spacing: 28) {
                    profileView
                        .frame(height: 50)
                        .padding(.horizontal, 16)
                    
                    mainSummaryView
                        .frame(height: 123)
                    
                    summaryView
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 12)
            .navigationTitle("2023년 6월 5일")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(BackgroundObject())
    }
    
}

extension SwimmingDetailView {
    
    private var mainSummaryView: some View {
        HStack {
            mainSummaryCell(.distance, data: data.unwrappedDistance.toString())
            
            mainSummaryCell(.paceAverage, data: data.unwrappedDistance.toString())

            mainSummaryCell(.totalTime, data: data.duration.toRelativeTime(.hourMinute))
        }
        .padding(.horizontal, 12)
    }
    
    private func mainSummaryCell(_ record: WorkoutRecordType, data: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.init(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.25), radius: 2.5, x: 0, y: 0)
            
            VStack(spacing: 8) {
                Image(record.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 30)
                    .foregroundColor(record.imageColor)
                
                
                HStack(alignment: .bottom, spacing: 0) {
                    Text(data)
                        .font(.custom(.sfProBold, size: 18))
                        .foregroundColor(.init(uiColor: .label))
                    Text(record.unit)
                        .font(.custom(.sfProBold, size: 14))
                        .foregroundColor(.init(uiColor: .label))
                        .lineLimit(1)
                }

                Text("\(record.title)")
                    .font(.custom(.sfProMedium, size: 14))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                    .lineLimit(1)
            }
        }
    }

    
    private var summaryView: some View {
        Group {
            GeometryReader { GeometryProxy in
                
                ZStack(alignment: .topLeading) {
                    
                    Rectangle()
                        .fill(Color.blue.opacity(0.1))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("요약")
                            .font(.custom(.sfProBold, size: 20))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                            .lineLimit(1)
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            summaryCell(.distance)
                            
                            summaryCell(.paceAverage)
                        }
                        .padding(.horizontal, 8)
                        
                        HStack(spacing: 20) {
                            summaryCell(.totalTime)
                            
                            summaryCell(.bpmAverage)
                        }
                        .padding(.horizontal, 8)
                        
                        HStack(spacing: 20) {
                            summaryCell(.activeKcal)
                            
                            summaryCell(.restKcal)
                        }
                        .padding(.horizontal, 8)
                        
                    }
                }
            }
            
        }
    }
    
    private func summaryCell(_ data: WorkoutRecordType) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(data.title)
                .font(.custom(.sfProMedium, size: 16))
                .foregroundColor(.init(uiColor: .secondaryLabel))
            
            Text("475")
                .font(.custom(.sfProMedium, size: 27))
                .foregroundColor(.init(uiColor: .label))
            + Text("m")
                .font(.custom(.sfProMedium, size: 20))
                .foregroundColor(.init(uiColor: .label))
        }
        .frame(minWidth: 100, idealWidth: 150)
        
    }
    
    private var profileView: some View {
        HStack(alignment: .center, spacing: 20) {
            Image("Avatar")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Heon Ha")
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundColor(.init(uiColor: .label))
                    .lineLimit(1)
                Text("2023년 06월 05일")
                    .font(.custom(.sfProLight, size: 14))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                    .lineLimit(1)
                
                Text("08:16~08:58")
                    .font(.custom(.sfProLight, size: 12))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image("location.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                    .frame(width: 14, height: 14)
                
                Text("서울특별시")
                    .font(.custom(.sfProMedium, size: 12))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                    .lineLimit(1)
            }
            .frame(width: 70, height: 20)
        }
    }
    
    
}

struct SwimmingDetailView_Previews: PreviewProvider {
    
    static let data = TestObjects.swimmingData.first!
    
    static var previews: some View {
        NavigationView {
            SwimmingDetailView(data: data)
        }
    }
    
}
