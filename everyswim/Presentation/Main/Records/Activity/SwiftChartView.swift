//
//  SwiftChartView.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/4/23.
//

import SwiftUI
import Charts

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

@available(iOS 16.0, *)
struct SwiftChartView: View {
    
    @ObservedObject var viewModel: ActivityViewModel
    
    init(viewModel: ActivityViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Chart {
            ForEach(viewModel.presentedData) { data in
                BarMark(
                    x: .value("Shape Type", data.date),
                    y: .value("Total Count", data.unwrappedDistance)
                  )
            }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SwiftChartView(viewModel: ActivityViewModel())
    } else {
        EmptyView()
    }
}
