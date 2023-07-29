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
            VStack {
                ForEach(data.laps.indices) { index in
                    let event = data.laps[index]
                    var lapIndex = 0
//                    if event.type == .lap {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.thinMaterial)
                            VStack {
                                HStack {
                                    Text("\(event.index)")
                                }
                                Text("\(event.dateInterval.start) ~ \(event.dateInterval.end)")
                                Text("\(event.style?.name() ?? "")")
                            }
                        }
                        .frame(height: 100)
                        .onAppear {
                            lapIndex += 1
                        }
//                    }
                    
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
