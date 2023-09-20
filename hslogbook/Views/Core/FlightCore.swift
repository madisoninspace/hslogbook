//
//  FlightCore.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct FlightCore: View {
    var body: some View {
        NavigationStack {
            FlightTable()
        }
        .modifier(GWToolbarRole(title: "Flights"))
    }
}

#Preview {
    FlightCore()
}
