//
//  RecordReuseCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit
import SnapKit

final class RecordReuseCell: UITableViewCell {
    
    static let reuseId = "RecordReuseCell"
    private var baseCell: EventListUICell!

    func setBaseCell(data: SwimMainData) {
        if let baseCell = baseCell {
            baseCell.updateData(data)
        } else {
            self.baseCell = EventListUICell(data: data)
            layout()
        }
        
        baseCell.updateTitle(data: data)
        baseCell.updateRecord(data: data)
    }
    
    private func layout() {
        baseCell.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
    
}
