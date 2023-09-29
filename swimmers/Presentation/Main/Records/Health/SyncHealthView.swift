// //
// //  SyncHealthView.swift
// //  swimmers
// //
// //  Created by HeonJin Ha on 2023/07/03.
// //
// 
// import SwiftUI
// import HealthKit
// 
// struct SyncHealthView: View {
//     
//     private var hkManager: HealthKitManager = .init()
//     
//     @State private var isAuth = false
//     @State private var authStatus: HKAuthorizationStatus = .notDetermined
//     @Environment(\.dismiss) private var dismiss
//     
//     var body: some View {
//         
//         VStack {
//             
//             Spacer()
//             
//             Image("AppleHealth")
//                 .resizable()
//                 .frame(width: 120, height: 120)
//                 .scaledToFill()
//             
//             Spacer()
//             
//             description()
//             
//             Spacer()
//             
//             checkButton()
//         }
//         .padding()
//         .onAppear {
//             self.authStatus = hkManager.checkAuthorizationStatus() ?? .notDetermined
//         }
//     }
//     
//     private func description() -> some View {
//         VStack(spacing: 12) {
//             Text("Apple 건강에서\n기록 가져오기")
//                 .font(.custom(.sfProBold, size: 24))
//                 .foregroundColor(.init(uiColor: .label))
//                 .multilineTextAlignment(.center)
//             
//             Text(switchButtonText(authStatus).message)
//                 .multilineTextAlignment(.center)
//                 .font(.custom(.sfProMedium, size: 18))
//                 .foregroundColor(.init(uiColor: .secondaryLabel))
//         }
//     }
//     
//     private func checkButton() -> some View {
//         Button {
//             authResultHandler()
//         } label: {
//             ZStack {
//                 RoundedRectangle(cornerRadius: 8)
//                     .fill(Color(hex: "2752EE"))
//                 
//                 Text(switchButtonText(authStatus).button)
//                     .font(.custom(.sfProBold, size: 18))
//                     .foregroundColor(.white)
//             }
//         }
//         .frame(height: 44)
//     }
//     
//     private func authResultHandler() {
//         switch authStatus {
//         case .notDetermined:
//             Task { await hkManager.requestAuthorization() }
//         case .sharingAuthorized:
//             dismiss()
//         case .sharingDenied:
//             UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=TRACKING")!, options: [:], completionHandler: nil) // 심사 때 거부될 수 있음.
//         @unknown default:
//             return
//         }
//     }
//     
//     private func switchButtonText(_ status: HKAuthorizationStatus) -> (message: String, button: String) {
//         
//         switch status {
//         case .notDetermined:
//             return (message: "기존의 기록을 반영하려면\nApple 건강 데이터를 가져오세요.", button: "계속하기")
//         case .sharingDenied:
//             return (message: "현재 권한이 거부되어있어요😢\n설정 - 개인정보 보호 및 보안 - 건강 - Swimmers를 클릭해서 권한을 승인해주세요.", button: "설정 열기  ")
//         case .sharingAuthorized:
//             return (message: "이미 권한이 승인 되었습니다.", button: "닫기")
//         @unknown default:
//             return (message: "기존의 기록을 반영하려면\nApple 건강 데이터를 가져오세요.", button: "계속하기")
//         }
//     }
// }
// 
// struct SyncHealthView_Previews: PreviewProvider {
//     static var previews: some View {
//         SyncHealthView()
//     }
// }
