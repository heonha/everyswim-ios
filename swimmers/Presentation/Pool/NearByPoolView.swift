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
                        NavigationLink {
                            SwimmingPoolMapView()
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
    
    private func searchBar() -> some View {
        TextField("수영장 검색", text: $text)
            .modifier(SearchBarModifier())
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
    }
    
    private func mainBody() -> some View {
        ZStack {
            VStack {

                searchBar()
                
                ScrollView {
                    VStack(spacing: 20) {
                        SwimmingPoolCell(pool: ._50plus)

                        SwimmingPoolCell(pool: .gochukdom)

                        SwimmingPoolCell(pool: .guronam)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.all, 14)
        
    }

}

struct SearchPoolView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NearByPoolView()
        }
    }
}
