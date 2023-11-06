//
//  FoodPrintApp.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 25/9/2023.
//

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
struct FoodPrintApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            //WelcomePageView()
            WelcomePageView()
                .onChange(of: scenePhase) { phase in
                    if phase == .background {
                        // App is entering the background, reset the app to the welcome page
                        resetAppToWelcomePage()
                    }
                }
        }
    }
    private func resetAppToWelcomePage() {
        // Reset app state, such as user authentication, to log out the user
        // ...
        
        // Create a new instance of the welcome page view
        let welcomePageView = WelcomePageView()
        
        // Reset the app's window root view controller to the welcome page view
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: welcomePageView)
            window.makeKeyAndVisible()
        }
    }
}
