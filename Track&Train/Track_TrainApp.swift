//
//  Track_TrainApp.swift
//  Track&Train
//
//  Created by Venkata reddy Gabbi on 5/29/25.
//

import SwiftUI

@main
struct Track_TrainApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
