//
//  HomeImageSlider.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/19/23.
//

import SwiftUI
import Combine

struct HomeImageSlider: View {
    
    @Binding var selection: Int
    @State private var cancellable: Cancellable?
    
    var body: some View {
        TabView(selection: $selection) {
            imageFrame(imageName: "ad-sample1", title: "타이틀", subtitle: "서브타이틀 입니다.")
                .tag(0)
            imageFrame(imageName: "ad-sample2", title: "타이틀", subtitle: "서브타이틀 입니다.")
                .tag(1)
            imageFrame(imageName: "ad-sample3", title: "타이틀", subtitle: "서브타이틀 입니다.")
                .tag(2)
        }
        .frame(height: 200)
        .onAppear {
            slideTimer()
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        
    }
    
    private func slideTimer() {
        cancellable = Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if selection <= 3 {
                    withAnimation {
                        self.selection += 1
                    }
                } else {
                    withAnimation {
                        selection = 0
                    }
                }
            }
    }
    
    private func imageFrame(imageName: String, title: String, subtitle: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay {
                ZStack {
                    Color.black.opacity(0.5)
                        .overlay(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(title)
                                    .font(.custom(.sfProBold, size: 25))
                                    .foregroundColor(.white)
                                
                                Text(subtitle)
                                    .font(.custom(.sfProMedium, size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                }
            }
    }
    
}

#Preview {
    HomeImageSlider(selection: .constant(0))
}
