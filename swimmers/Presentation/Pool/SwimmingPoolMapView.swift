//
//  SwimmingPoolMapView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI
import MapKit

struct SwimmingPoolMapView: View {
    
    @State private var text = ""
    @State private var mapRect = MKMapRect(x: 0, y: 0, width: 300, height: 300)
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    TextField("수영장 검색", text: $text)
                        .modifier(SearchBarModifier())
                }
                .frame(height: 50)
                
                Map(mapRect: $mapRect)
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("주변 수영장 찾기")
                    .font(.custom(.sfProBold, size: 17))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct SwimmingPoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        SwimmingPoolMapView()
    }
}
