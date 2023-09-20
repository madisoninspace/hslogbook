//
//  AirportCore.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirportCore: View {
    @State private var displayMode: Int = 0
    
    var body: some View {
        NavigationStack {
            switch displayMode {
                case 0:
                    AirportTable()
                    
                case 1:
                    AirportMap()
                    
                default:
                    Text("How'd you get here?")
            }
        }
        .modifier(GWToolbarRole(title: "Airports"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Picker(selection: $displayMode.animation(), content: {
                    Image(systemName: "tablecells")
                        .tag(0)
                    
                    Image(systemName: "map")
                        .tag(1)
                }, label: {
                    
                }).pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AirportCore()
            .modelContainer(previewContainer)
    }
}
