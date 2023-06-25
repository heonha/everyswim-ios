//
//  NearByPoolView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct NearByPoolView: View {
    
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            
            mainBody()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("map")
                        } label: {
                            Image(systemName: "map")
                                .foregroundColor(.black)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("주변 수영장 찾기")
                            .font(.custom(.sfProBold, size: 17))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
}

extension NearByPoolView {
    
    private func mainBody() -> some View {
        ZStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ThemeColor.cellBackground)
                        .frame(height: 42.5)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "magnifyingglass")
                            .frame(height: 15)
                        
                        TextField("수영장 검색", text: $text)
                            .autocorrectionDisabled()
                            .textCase(.none)
                    }
                    .padding(.horizontal)
                    .foregroundColor(ThemeColor.grayTint)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        swimmingPoolCell(pool: ._50plus)
                        swimmingPoolCell(pool: .gochukdom)
                        swimmingPoolCell(pool: .guronam)
                    }
                }
                
                
                Spacer()
            }
        }
        .padding(.all, 14)
        
    }
    
    enum SwimmingPool: String {
        
        case _50plus = "구로 50플러스 수영장"
        case gochukdom = "고척돔체육센터 수영장"
        case guronam = "구로남체육센터 수영장"
        
        func getImage() -> String {
            switch self {
                
            case ._50plus:
                return "pool1"
            case .gochukdom:
                return "pool2"
            case .guronam:
                return "pool3"
            }
        }
        
    }
    
    private func swimmingPoolCell(pool: SwimmingPool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
            
            Image(pool.getImage())
                .resizable()
                .frame(height: 192)
                .cornerRadius(8)
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                    
                    
                    VStack(spacing: 4) {
                        HStack {
                            Text(pool.rawValue)
                                .font(.custom(.sfProBold, size: 16))
                            Spacer()
                        }
                        
                        HStack(spacing: 3) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.init(hex: "3284FE"))
                            
                            Text("서울특별시 구로구 오류로 36-25 50플러스남부캠퍼스(지하2층)")
                                .foregroundColor(.init(hex: "000000").opacity(0.42))
                            
                            Spacer()
                        }
                        .font(.custom(.sfProLight, size: 12))
                        
                        HStack {
                            Text("평일 07:00~21:00")
                                .foregroundColor(.init(hex: "000000").opacity(0.42))
                                .padding(.leading, 8)
                            Text("토요일 09:00~18:00")
                                .foregroundColor(.init(hex: "000000").opacity(0.42))
                            Text("일요일 휴무")
                                .foregroundColor(.init(hex: "000000").opacity(0.42))
                            Spacer()
                        }
                        .font(.custom(.sfProLight, size: 12))
                        
                    }
                    .padding(.horizontal, 9)
                }
                .frame(height: 74)
                
            }
        }
        .frame(height: 192)
    }
    
}

struct SearchPoolView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NearByPoolView()
        }
    }
}
