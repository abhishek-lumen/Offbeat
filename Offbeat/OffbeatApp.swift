//
//  OffbeatApp.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI

@main
struct OffbeatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

//enum Theme {
//    case light
//    case dark
//}
//
//extension Color {
//    static func themeColor(_ theme: Theme) -> Color {
//        switch theme {
//        case .light:
//            let yellow = Color.yellow
//            return yellow
//        case .dark:
//            let yellow = Color.blue
//            return yellow
//        }
//    }
//}
