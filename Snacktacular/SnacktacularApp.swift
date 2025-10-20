//
//  SnacktacularApp.swift
//  Snacktacular
//
//  Created by Ron Lemire on 10/17/25.
//

// Ch. 8.13 Part 2 - SwiftUI @Firstone Query - Finishing Adding & Viewing Reviews (Snacktacular App)
// Ch. 8.14 Improving the UI w/better Review Rows + Preventing Edits of Reviews a User Didn't Post
// Ch. 8.15 Delete Data from Cloud Firstore using SwiftUI Snacktacular App

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct SnacktacularApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
