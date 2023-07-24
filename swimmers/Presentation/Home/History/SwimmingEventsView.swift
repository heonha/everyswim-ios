//
//  SwimmingEventsView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import SwiftUI

struct SwimmingEventsView: View {
    
    let data: SwimmingData
    
    var body: some View {

        ScrollView {
            VStack {
                ForEach(data.events.indices) { index in
                    let event = data.events[index]
                    var lapIndex = 0
                    if event.type == .lap {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.thinMaterial)
                            VStack {
                                HStack {
                                    Text("\(index)")
                                    Text("\(event.type.name)")
                                }
                                Text("\(event.start) ~ \(event.end)")
                                Text("\(event.duration.toRelativeTime(.hourMinuteSeconds))")
                                Text("\(event.style)")
                            }
                        }
                        .frame(height: 100)
                        .onAppear {
                            lapIndex += 1
                        }
                    }
                    
                }
            }
        }
        
    }
}

struct SwimmingEventsCell_Previews: PreviewProvider {
    static var previews: some View {
        SwimmingEventsView(data: TestObjects.swimmingData.first!)
    }
}
