//
//  BaseDatePicker.swift
//  everyswim
//
//  Created by HeonJin Ha on 1/14/24.
//

import UIKit
import SnapKit
import CombineCocoa

class BaseDatePickerViewcontroller: BaseViewController, UISheetPresentationControllerDelegate {

    static let exampleComponent = ["comp1", "comp2"]
    static let exampleRows = [["comp1-row1", "comp1-row2"], ["comp2-row1", "comp2-row2"]]
    
    let datePicker = UIPickerView()
    var rowHeight: CGFloat
    
    var components: [String] = []
    var rows: [[String]] = [[]]
        
    // MARK: - Init
    init(rowHeight: CGFloat = 50) {
        self.rowHeight = rowHeight
        super.init()
        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
    }
    
    // MARK: Configure
    func configure() {

    }

    func layout() {
        self.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setComponents(_ components: [String]) {
        self.components.removeAll()
        self.components = components.reversed()
    }
    
    func setRows(_ data: [[String]]) {
        rows.removeAll()
        self.rows = data.reversed()
    }
        
    func setRowHeight() {
        
    }
    
}
// MARK: - Preview
#if DEBUG
import SwiftUI

struct BaseDatePickerViewcontroller_Previews: PreviewProvider {
    
    static let vc = BaseDatePickerViewcontroller(rowHeight: 50)
    static let components = BaseDatePickerViewcontroller.exampleComponent
    static let rows = BaseDatePickerViewcontroller.exampleRows
    
    static var previews: some View {
        UIViewControllerPreview {
            vc
        }
        .ignoresSafeArea()
        .onAppear {
            vc.setComponents(components)
            vc.setRows(rows)
        }
    }
}
#endif
