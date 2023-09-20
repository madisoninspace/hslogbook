//
//  MainView.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selection: AppScreen? = .aircraft
    
    var body: some View {
        NavigationSplitView {
            AppSidebarList(selection: $selection)
            #if os(macOS)
                .navigationSplitViewColumnWidth(200.0)
            #endif
        } detail: {
            AppDetailColumn(screen: selection)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(previewContainer)
}
