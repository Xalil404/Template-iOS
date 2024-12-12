//
//  Template_iOSApp.swift
//  Template-iOS
//
//  Created by TEST on 12.12.2024.
//
import GoogleSignIn
import SwiftUI

@main
struct Template_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                                                    GIDSignIn.sharedInstance.handle(url)  // Handle the URL for Google Sign-In
                                                }
        }
    }
}
