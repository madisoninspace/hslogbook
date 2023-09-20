//
//  AppSidebarList.swift
//  Gateway
//
//  Created by Hannah Wass on 9/17/23.
//

import SwiftUI

struct AppSidebarList: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        List(AppScreen.allCases, selection: $selection) { screen in
            NavigationLink(value: screen) {
                screen.label
            }
        }
        .navigationTitle("HSL ✈️")
    }
}

#Preview {
    NavigationSplitView {
        AppSidebarList(selection: .constant(.typeDesignators))
    } detail: {
        Text(verbatim: "<--")
    }
    .modelContainer(previewContainer)
}
