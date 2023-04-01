//
//  PintQuestApp.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI

@main
struct PintQuestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
