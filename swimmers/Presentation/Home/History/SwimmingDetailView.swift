//
//  SwimmingDetailView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/24.
//

import SwiftUI

struct SwimmingDetailView: View {
    
    let data: SwimmingData
    @Environment(\.colorScheme) var colorScheme
    
}

extension SwimmingDetailView {
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 28) {
                profileView
                    .frame(height: 50)
                    .padding(.horizontal, 16)
                
                mainSummaryView
                    .frame(height: 123)
                
                summaryView
                
                Rectangle()
                    .fill(Color.clear)
            }
            .padding(.vertical)
        }
        .background(BackgroundObject())
        .padding(.horizontal, 12)
        .navigationTitle("\(data.startDate.toString(.fullDateKr))")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

extension SwimmingDetailView {
    
    private var mainSummaryView: some View {
        HStack(spacing: 12) {
            mainSummaryCell(.distance, data: data.unwrappedDistance.toString())
            
            mainSummaryCell(.paceAverage, data: "1:39/25")

            mainSummaryCell(.totalTime, data: data.duration.toRelativeTime(.hourMinute))
        }
        .padding(.horizontal, 12)
    }
    
    private func mainSummaryCell(_ record: WorkoutRecordType, data: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .light ? .ultraThickMaterial : .thinMaterial)
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
                        .font(.custom(.sfProBold, size: 20))
                        .foregroundColor(.init(uiColor: .label))
                    Text(record.unit)
                        .font(.custom(.sfProBold, size: 16))
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
            GeometryReader { proxy in
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color.clear)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("요약")
                            .font(.custom(.sfProBold, size: 20))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                            .lineLimit(1)
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            
                            summaryVStack(width: (proxy.size.width / 2.1) - 10) {
                                summaryCell(.distance, data: data.unwrappedDistance.toString())
                                summaryCell(.totalTime, data: data.durationString)
                                summaryCell(.activeKcal, data: data.activeKcal?.toString() ?? "")
                            }
                            
                            summaryVStack(width: (proxy.size.width / 2.1) - 10) {
                                summaryCell(.paceAverage, data: "1:39/25")
                                summaryCell(.bpmAverage, data: "100")
                                summaryCell(.restKcal, data: data.restKcal?.toString() ?? "")
                            }

                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    private func summaryVStack<Content: View>(width: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, content: content)
            .frame(width: width)
    }
    
    private func summaryCell(_ type: WorkoutRecordType, data: String) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.clear)
                VStack(alignment: .leading, spacing: 2) {
                    Text(type.title)
                        .font(.custom(.sfProMedium, size: 16))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                    
                    Text("\(data)")
                        .font(.custom(.sfProMedium, size: 27))
                        .foregroundColor(.init(uiColor: .label))
                    + Text("\(type.unit)")
                        .font(.custom(.sfProMedium, size: 20))
                        .foregroundColor(.init(uiColor: .label))
                }
        }
        
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
