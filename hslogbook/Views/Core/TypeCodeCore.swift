//
//  TypeCodeCore.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct TypeCodeCore: View {
    @State var displayMode: Int = 0
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            switch displayMode {
                case 0:
                    TypeCodeTable()
                    
                case 1:
                    TypeCodeStatistics()
                    
                default:
                    Text("How'd you end up here?")
            }
        }
        .modifier(GWToolbarRole(title: "Type Codes"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Picker(selection: $displayMode.animation(.bouncy), content: {
                    Image(systemName: "tablecells")
                        .tag(0)
                    
                    Image(systemName: "chart.pie")
                        .tag(1)
                }, label: {
                    
                }).pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    NavigationSplitView {
        
    } detail: {
        TypeCodeCore()
            .modelContainer(previewContainer)
    }
}
