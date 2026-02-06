//
//  AppDelegate.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 03/04/25.
//
import FirebaseCore
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
