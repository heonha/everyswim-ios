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
                
                ForEach(data.laps.indices) { index in
                    let event = data.laps[index]
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                        HStack {
                            HStack {
                                Text("Lap")
                                    .font(.custom(.sfProMedium, size: 16))
                                Text("\(event.index)")
                                    .font(.custom(.sfProBold, size: 20))
                                    .foregroundColor(.init(uiColor: .secondaryLabel))
                            }
                            .padding(.leading)
                            
                            Spacer()

                            VStack {
                                Text("랩 타임")
                                    .font(.custom(.sfProMedium, size: 16))
                                Text(event.dateInterval.duration.toRelativeTime(.hourMinuteSeconds))
                                    .font(.custom(.sfProBold, size: 20))
                                    .foregroundColor(.init(uiColor: .secondaryLabel))
                            }
                            
                            Spacer()

                            
                            VStack {
                                Text("스타일")
                                    .font(.custom(.sfProMedium, size: 16))
                                Text("\(event.style?.name ?? "")")
                                    .font(.custom(.sfProBold, size: 20))
                                    .foregroundColor(.init(uiColor: .secondaryLabel))
                            }
                            
                            Spacer()
                        }
                    }
                    .frame(height: 70)
                }
            }
        }
        
    }
}

struct SwimmingEventsCell_Previews: PreviewProvider {
    static var previews: some View {
        SwimLapsView(data: TestObjects.swimmingData.first!)
    }
}
