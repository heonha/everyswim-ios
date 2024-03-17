//
//  TotalRecordView.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/16/24.
//

import SwiftUI

struct TotalRecordView: View {
    
    @State private var selectedOption: ActivityDataRange = .weekly

    var body: some View {
        VStack {
            
            Picker("Option", selection: $selectedOption) {
                ForEach(ActivityDataRange.allCases) { target in
                    Text(target.segmentTitle).tag(target)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                
                VStack {
                    
                    Spacer()

                    // 선택된 세그먼트에 따른 콘텐츠 표시
                    Button {
                        
                    } label: {
                        Text("\(selectedOption.segmentSubtitle)")
                            .foregroundStyle(Color.init(uiColor: .label))
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        Text("1,500")
                            .font(.custom(.sfProBold, size: 60))
                        Text("Meters")
                            .font(.custom(.sfProMedium, size: 20))
                            .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.clear)
                        HStack(spacing: 16) {
                            subRecordCell(title: "수영", value: "3")
                            Divider()
                            subRecordCell(title: "평균페이스", value: "1'11''")
                            Divider()
                            subRecordCell(title: "시간", value: "00:00")
                        }
                    }
                    .frame(height: 100)
                    
                    Spacer()
                    
                }
            }
            .frame(height: 270)
            
            Divider()
            
            Text("\(selectedOption.segmentTitle) 활동")
                .font(.custom(.sfProBold, size: 18))
                .frame(height: 50)
            
            RecordCard(record: .default)

            Spacer()
        }
        .padding(.horizontal)

    }
    
    private func subRecordCell(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.custom(.sfProBold, size: 24))
            Text(title)
                .font(.custom(.sfProMedium, size: 16))
                .foregroundStyle(Color.secondary)
        }
        .frame(width: AppConstant.deviceSize.width / 5)
    }

}

#Preview {
    TotalRecordView()
}
