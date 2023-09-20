//
//  AircraftCore.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AircraftCore: View {
    var body: some View {
        NavigationStack {
            AircraftTable()
        }
        .modifier(GWToolbarRole(title: "Aircraft"))
    }
}

#Preview {
    AircraftCore()
}
