//
//  AirportCore.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirportCore: View {
    var body: some View {
        NavigationStack {
            AirportTable()
        }
        .modifier(GWToolbarRole(title: "Airports"))
    }
}

#Preview {
    AirportCore()
}
