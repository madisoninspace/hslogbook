//
//  hslogbookApp.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

@main
struct HSLApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Aircraft.self,
            Airline.self,
            Airport.self,
            Flight.self,
            SpottingLocation.self,
            TypeCode.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
