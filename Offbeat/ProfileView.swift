//
//  ProfileView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 29/03/25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var showProfileView: Bool
    @State var selected: Int = 0
    @State private var isFloating = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(.brown)
                        .padding(.horizontal, 30)
                    Spacer()
                    Button(action: {
                        self.showProfileView.toggle()
                    }) {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 30)
                    }
                }
                
                Divider()
                    .background(Color.brown)
                    .padding(.horizontal, 30)
                
                QFStepperView(model: QFStepperModel(totalSteps: 6, selectedStep: $selected))
                    .padding(.vertical, 30)
                
//                let wd: Float = Float(UIScreen.main.bounds.width)
//                Text("\(wd)")
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.opacity(0.1))
        .background(Color.white)
        .onTapGesture {
            // Prevent dismissal when tapping inside the view
        }
    }
}


struct QFStepperModel {
    var totalSteps: Int
    @Binding var selectedStep: Int
}

struct QFStepperView: View {
    var model: QFStepperModel
    
    var body: some View {
        HStack(spacing: 0) {
            let maxWidth = ((model.totalSteps - 1) * 50) + (model.totalSteps * 24) - 32
            let viewWidth: Int = Int(UIScreen.main.bounds.width - 32)
            ForEach(0..<model.totalSteps, id: \.self) { index in
                ZStack {
                    if index < model.selectedStep {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 24, height: 24)
                        Text("\(index + 1)")
                            .font(.callout)
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .stroke(Color.purple.opacity(0.4), lineWidth: 1)
                            .frame(width: 24, height: 24)
                        Text("\(index + 1)")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                }
                
                if index < model.totalSteps - 1 {
                    Rectangle()
                        .fill(index < model.selectedStep ? Color.purple : Color.purple.opacity(0.4))
                        .frame(width: maxWidth < viewWidth ? 50 : .infinity, height: 1)
                }
            }
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut, value: model.selectedStep)
    }
}


//extension Color {
//    static let yellow = Color.blue
//    static let brown = Color.black.opacity(0.8)
//}

#Preview {
    ProfileView(showProfileView: Binding.constant(false))
}

