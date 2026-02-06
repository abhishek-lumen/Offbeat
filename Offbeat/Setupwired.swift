//
//  QFSetUpWiredPod.swift
//  QuantumFiber
//
//  Created by Gupta, Abhishek on 10/07/25.
//  Copyright © 2025 Digital Products. All rights reserved.
//

import SwiftUI

struct QFSetUpWiredPod: View {
    @State var selected: Int
    @State var isForward: Bool? = false
    
    
    var body: some View {
        //isForward = false
        ZStack {
            Color.gray.opacity(0.1)
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                VStack {
                    QFStepperView(model: QFStepperModel(totalSteps: 4, selectedStep: $selected))
                        .padding(.top, 12)
                        .padding(.bottom, 25)
                    
                    ZStack {
                        VStack {
                            switch selected {
                            case 0:
                                QFSetUpWiredPodWelcome()
                                    .transition(.move(edge: .leading))
                            case 1:
                                QFSetUpWiredPodNameYourNetwork()
                                    //.transition(selected == 1 ? .move(edge: .leading) : (isForward ?? false ? .asymmetric(insertion: .move(edge: .trailing), removal : .slide) : .slide))
                                    //.transition(isForward ?? false ? .asymmetric(insertion: .move(edge: .trailing), removal : .slide) : .slide)
                                    .transition(isForward ?? false ? .asymmetric(insertion: .asymmetric(insertion: .move(edge: .trailing), removal : .move(edge: .trailing)), removal : .slide) : .slide)
                            default:
                                QFSetUpWiredPodEquipments(selected: $selected)
                                    .transition(selected == 2 ? .move(edge: .trailing) : .opacity)
                                //.transition((selected == 2 && !isForward) ? .move(edge: .trailing) : .opacity)
                            }
                        }
                    }
                    
                    .animation(.default, value: selected)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isForward = true
                        if selected >= 0 && selected < 4 {
                            
                            selected += 1
                        } else {
                            selected = selected
                        }
                    }) {
                        Text("Next")
                    }
                    //.buttonStyle(WideButton(type: .primary))
                    .padding(.bottom, 25)
                    
                    Spacer()
                    
                    Button(action: {
                        isForward = false
                        if selected > 0 && selected <= 4 {
                            selected -= 1
                        } else {
                            selected = selected
                        }
                    }) {
                        Text("Back")
                    }
                    //.buttonStyle(WideButton(type: .primary))
                    .padding(.bottom, 25)
                }
                .padding(.horizontal, 50)
            }
        }
    }
}

struct QFSetUpWiredPodWelcome: View {
    var body: some View {
        Text("Setting up your wireless network is the first step to get a seamless Wi-Fi connection.\n\nThe process is quick, typically taking just 5 to 10 minutes, and involves four simple steps:")
            .font(.caption)
            .foregroundColor(Color.gray)
            .padding(.horizontal, 16)
        
        VStack(spacing: 4) {
            QFSetUpWiredPodCardView(index: "1", title: "Name Your Network")
            QFSetUpWiredPodCardView(index: "2", title: "Gather Your Equipment")
            QFSetUpWiredPodCardView(index: "3", title: "Connect Your Equipment")
            QFSetUpWiredPodCardView(index: "4", title: "Plug In The Pod")
        }
        .padding(.vertical, 8)
    }
}

struct QFSetUpWiredPodNameYourNetwork: View {
    @State private var networkName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("To keep your devices connected automatically to the new network, make sure the name and password of your new network are the same as your previous one.")
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(.horizontal, 16)
            
            Text("Network Name")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 5)
            
            TextField("Network Name (SSID)", text: $networkName)
                .background(.white)
                .padding()
            
            
            
            QFTextField(title: "Network Name (SSID)", type: .normal, text: $networkName)
            
            
            
            Text("Network Password")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            TextField("Password", text: $password)
                .background(.white)
                .padding()
            
            TextField("Confirm Password", text: $confirmPassword)
                .background(.white)
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

struct QFSetUpWiredPodEquipments: View {
    @Binding var selected: Int
    var body: some View {
        Image(selected == 2 ? .qfGatherYourEquipment : (selected == 3 ? .qfConnectYourEquipment : .qfPlugInThePod))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .cornerRadius(selected == 4 ? 20 : 0)
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        
        
        VStack(spacing: 4) {
            QFSetUpWiredPodCardView(index: "A", title: "SmartNID").opacity(selected == 4 ? 0.5 : 1)
            QFSetUpWiredPodCardView(index: "B", title: "Ethernet Cable").opacity(selected == 4 ? 0.5 : 1)
            QFSetUpWiredPodCardView(index: "C", title: "Wired Pod")
            QFSetUpWiredPodCardView(index: "D", title: "Power Cord").opacity(selected == 3 ? 0.5 : 1)
        }
        .padding(.vertical, 8)
        
        if selected == 3 || selected == 4 {
            Text(selected == 3 ? "Connect the SmartNID (A) 10G WAN port to the port with the same name on the Wired Pod (C) using the Ethernet Cable (B)." : "Connect the Wired Pod (C) to an electrical outlet through the Power port. Use the Power Cord (D).")
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(.horizontal, 16)
        }
    }
}

struct QFSetUpWiredPodCardView: View {
    var index: String
    var title: String
    var activeState: Bool = true
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(activeState ? 0.1 : 0.05))
                        .frame(width: 24, height: 24)
                    Text(index)
                        .font(.caption)
                        .foregroundColor(Color.purple.opacity(activeState ? 1 : 0.5))
                }
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.gray.opacity(activeState ? 1 : 0.5))
                Spacer()
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(activeState ? 1 : 0.5))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}



#Preview {
   // QFSetUpWiredPod(selected: 0 , isForward: false)
    QFSetUpWiredPod(selected: 0 )
}


enum HintType {
    case onTopRight
    case onBottomLeft
    case onBottomRight
    case onTheField
    case none
}

struct QFTextField: View {
    @State private var isSecure: Bool
    @Binding var text: String
    @State private var isEditing: Bool = false
    @State private var hintType: HintType
    @Binding var errorStr: String?
    
    var updatedText: ((String) -> Void)?
    var title: String
    var type: TextFieldType
    var hint: String?
    
    init(title: String, type: TextFieldType, text: Binding<String>, hint: String? = nil, hintType: HintType = .none, errorStr: Binding<String?> = .constant(nil), updatedText: ((String) -> Void)? = nil){
        self.title = title
        self.type = type
        self._text = text
        self._isSecure = State(initialValue: type == .password)
        self.hint = hint
        self.hintType = hintType
        self._errorStr = errorStr
        self.updatedText = updatedText
        if let handler = updatedText {
            handler(self.text)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                if isEditing || !text.isEmpty {
                    VStack {
                        Text(title)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 5)
                            .padding(.leading, 15)
                            .transition(.move(edge: .trailing))
                            .animation(.default, value: isEditing)
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.default, value: isEditing)
                }
                    
                if let hint = hint, hintType == .onTopRight {
                    Text(hint)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                }
            }
            HStack {
                if type == .password && isSecure {
                    SecureField(title, text: $text, onCommit: {
                        isEditing = false
                    })
                    .foregroundColor(Color.gray)
                    .frame(height: 20)
                    .onTapGesture {
                        isEditing = true
                    }
                    if hintType == .onTheField, let hint = hint, !isEditing, text.isEmpty {
                        Text(hint)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .layoutPriority(1)
                            .lineLimit(1)
                    }
                } else {
                    TextField(isEditing ? "" : title, text: $text, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .foregroundColor(Color.gray)
                    .frame(height: 20)
                    .keyboardType(type == .email ? .emailAddress : .default)
                    if hintType == .onTheField, let hint = hint, !isEditing, text.isEmpty {
                        Text(hint)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .layoutPriority(1)
                            .lineLimit(1)
                    }
                }
                
                if type == .password {
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundColor(Color.purple)
                    }
                }
            }
            .padding(16)
            .background((errorStr == nil) ? Color.white : Color.red.opacity(0.1))
            .cornerRadius(12)
            if let hint = hint, hintType != .onTopRight, hintType != .onTheField {
                Text(hint)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: hintAlignment)
            }
            
            if let error = errorStr {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle")
                    Text(error)
                }
                .foregroundColor(Color.red)
                .font(.body)
                .padding(.top, 6)
                .padding(.leading, 15)
            }
        }
        .accessibilityLabel("\(title) TextField")
    }
    
    private var hintAlignment: Alignment {
        switch hintType {
        case .onBottomLeft: return .leading
        case .onBottomRight: return .trailing
        case .onTopRight: return .trailing
        case .onTheField: return .leading
        case .none: return .center
        }
    }
}

enum TextFieldType: Int {
    case email = 101
    case password
    case confirmPassword
    case mobile
    case normal
}

