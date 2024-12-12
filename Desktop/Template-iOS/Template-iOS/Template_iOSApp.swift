//
//  Template_iOSApp.swift
//  Template-iOS
//
//  Created by TEST on 12.12.2024.
//

import SwiftUI

@main
struct Template_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
