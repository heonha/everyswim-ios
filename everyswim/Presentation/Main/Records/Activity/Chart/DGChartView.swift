//
//  WeeklyChartView.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/4/23.
//

import UIKit
import SnapKit
import Combine
import DGCharts

final class DGChartView: UIView, CombineCancellable {

    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ActivityViewModel
    private let contentView = UIView()
    private lazy var barChartView: BarChartView = createChart()
    var entries = [BarChartDataEntry]()

    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
        layout()
        observe()
        
        chartAxis()
        configureLegend()
        setData([])
    }
    
    private func configure() {
        self.addSubview(contentView)
        contentView.addSubview(barChartView)
        
    }
    
    private func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        barChartView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    // MARK: - Chart View 생성
    private func createChart() -> BarChartView {
        
        let width = contentView.frame.size.width
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let barChartView = BarChartView(frame: frame)
        barChartView.center = contentView.center
        barChartView.fitBars = true
        barChartView.doubleTapToZoomEnabled = false
        barChartView.pinchZoomEnabled = false
        return barChartView
    }
    
    // MARK: - Axis Layout : 범례 객체
    private func chartAxis() {
        // MARK: AXIS (선 / font, line, color 등등 구성 변경)
        let xAxis = barChartView.xAxis
        xAxis.gridLineWidth = 0
        xAxis.drawAxisLineEnabled = false
            xAxis.labelPosition = .bottom
        
        // xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.weekdays)

        let rightAxis = barChartView.rightAxis
        rightAxis.gridColor = .blue
        rightAxis.gridLineWidth = 0
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false

        let leftAxis = barChartView.leftAxis
        leftAxis.gridColor = .red
        leftAxis.gridLineWidth = 0
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
    }
    
    private func observe() {
        viewModel.$selectedSegment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] segment in
                
                var values: [String] = []
                
                switch segment {
                case .weekly:
                    values = ["week"]
                case .monthly:
                    values = self?.viewModel.pickerMonths ?? [""]
                case .yearly:
                    values = ["year"]
                case .total:
                    values = ["total"]
                }
                
                self?.setIndexAxisValue(values: values)
                self?.setData(self?.viewModel.presentedData ?? [])
                self?.barChartView.setNeedsDisplay()
            }
            .store(in: &cancellables)
    }
    
    func setIndexAxisValue(values: [String]) {
        self.barChartView.xAxis.valueFormatter =
        IndexAxisValueFormatter(values: values)
    }
    
    // MARK: - `Legend`: 범례 객체
    private func configureLegend() {
        let legend = barChartView.legend
        legend.enabled = false
    }
    

    
    // MARK: - DATA ENTRY (데이터)
    private func setData(_ data: [SwimMainData]) {
        guard !data.isEmpty else { return }
        
        self.entries.removeAll()
        // TODO: 0 SwiftLint 추가하기

        
        // TODO: 1 Date 쿼리 만들기
        // 일간
        // 오늘 ~ 과거 7일
        
        // 주간
        // 이번주 ~ 과거 8주
        
        // 월간
        // 이번 월 ~ 과거 6개월
        
        // 연간
        // 이번 연도 ~ 과거 5 개년
        
        for index in 0...5 {
            let entry = BarChartDataEntry(x: Double(index),
                                          y: Double.random(in: 100...600))
            self.entries.append(entry)
        }
        
        print("changed Entry: \(self.entries.count)")
        
        // MARK: SET
        let set = BarChartDataSet(entries: entries, label: "Cost")
        set.colors =  [NSUIColor(hex: "08467D")]
        
        // MARK: DATA
        let data = BarChartData(dataSet: set)
        data.barWidth = 0.8
        data.isHighlightEnabled = true
        
        // 데이터 적용
        barChartView.data = data
    }
    
}

#if DEBUG
import SwiftUI

struct WeeklyChartView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ActivityViewController()
        }
        .ignoresSafeArea()
    }
}
#endif
