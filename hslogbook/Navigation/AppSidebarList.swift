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
        List(selection: $selection) {
            Section(content: {
                ForEach(AppScreen.allCases, id: \.self) { screen in
                    NavigationLink(value: screen) {
                        screen.label
                    }
                }
            }, header: {
                Text("Data")
            })
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
