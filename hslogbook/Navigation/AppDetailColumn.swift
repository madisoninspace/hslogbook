//
//  AppDetailColumn.swift
//  Gateway
//
//  Created by Hannah Wass on 9/17/23.
//

import SwiftUI

struct AppDetailColumn: View {
    var screen: AppScreen?
    
    var body: some View {
        Group {
            if let screen {
                screen.destination
            } else {
                ContentUnavailableView("Hannah's Spotting Logbook", systemImage: "airplane.arrival", description: Text("Select a menu option to begin."))
            }
        }
        #if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        #endif
    }
}

#Preview {
    AppDetailColumn()
        .modelContainer(previewContainer)
}
