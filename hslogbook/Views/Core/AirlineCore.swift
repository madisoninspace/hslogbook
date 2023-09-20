//
//  AirlineCore.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirlineCore: View {
    var body: some View {
        NavigationStack {
            AirlineTable()
        }
        .modifier(GWToolbarRole(title: "Airlines"))
    }
}

#Preview {
    AirlineCore()
}
