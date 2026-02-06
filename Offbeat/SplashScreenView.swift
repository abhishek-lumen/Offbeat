//
//  SplashScreenView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.5
    @State private var opacity = 0.1
    
    var body: some View {
        if isActive {
            LandingPageView()
        } else {
            ZStack {
                Color.yellow.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.5)) {
                                self.size = 1.5
                                self.opacity = 1.0
                            }
                        }
                }
                
                VStack(spacing: 5) {
                    Text("Off Beat")
                        .font(.title)
                        .fontWeight(.light)
                    Text("Discover the Unseen, Embrace the Adventure")
                        .font(.caption)
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .foregroundColor(.brown)
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
