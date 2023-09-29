// //
// //  SwimmingPoolCell.swift
// //  swimmers
// //
// //  Created by HeonJin Ha on 2023/06/25.
// //
// 
// import SwiftUI
// 
// struct SwimmingPoolCell: View {
//     
//     private let pool: SwimmingPool
//     
//     init(pool: SwimmingPool) {
//         self.pool = pool
//     }
//     
// }
// 
// extension SwimmingPoolCell {
//     
//     var body: some View {
//         ZStack {
//             
//             Image(pool.getImage())
//                 .resizable()
//                 .frame(height: 192)
//                 .cornerRadius(8)
//             
//             informationContainer()
// 
//         }
//         .frame(height: 192)
//         .padding(2)
//     }
//     
//     private func informationContainer() -> some View {
//         VStack {
//             Spacer()
//             VStack(spacing: 4) {
//                 poolNameView()
//                 
//                 addressView()
//                 
//                 openTimeView()
//             }
//             .padding(.horizontal, 8)
//             .frame(height: 74)
//             .background(CellBackground(cornerRadius: 0, material: .ultraThickMaterial))
//         }
//     }
//     
//     private func poolNameView() -> some View {
//         HStack {
//             Text(pool.rawValue)
//                 .font(.custom(.sfProBold, size: 16))
//             Spacer()
//         }
//     }
//     
//     private func addressView() -> some View {
//         HStack(spacing: 3) {
//             Image(systemName: "mappin.circle.fill")
//                 .foregroundColor(.init(hex: "3284FE"))
//             
//             Text("서울특별시 구로구 오류로 36-25 50플러스남부캠퍼스(지하2층)")
//                 .foregroundColor(.init(uiColor: .secondaryLabel))
//             
//             Spacer()
//         }
//         .font(.custom(.sfProLight, size: 12))
//     }
//     
//     private func openTimeView() -> some View {
//         HStack {
//             Text("평일 07:00~21:00")
//                 .foregroundColor(.init(uiColor: .secondaryLabel))
//                 .padding(.leading, 8)
//             Text("토요일 09:00~18:00")
//                 .foregroundColor(.init(uiColor: .secondaryLabel))
//             Text("일요일 휴무")
//                 .foregroundColor(.init(uiColor: .secondaryLabel))
//             Spacer()
//         }
//         .font(.custom(.sfProLight, size: 12))
//     }
//     
//     
// }
// 
// struct SwimmingPoolCell_Previews: PreviewProvider {
//     static var previews: some View {
//         SwimmingPoolCell(pool: ._50plus)
//     }
// }
