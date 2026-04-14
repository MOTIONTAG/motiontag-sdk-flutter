//
//  RunnerApp.swift
//  Runner
//
//  Created by Kian Mehravaran on 13.04.26.
//

import SwiftUI

@main
struct RunnerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
