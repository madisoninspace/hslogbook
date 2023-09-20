//
//  AirportMap.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import MapKit
import SwiftData
import SwiftUI

struct AirportMap: View {
    @Query(sort: [
        SortDescriptor(\Airport.icao),
        SortDescriptor(\Airport.name)
    ], animation: .spring) private var airports: [Airport]
    
    var body: some View {
        Map {
            ForEach(airports) { airport in
                if airport.latitude != 0.0 && airport.longitude != 0.0 {
                    Marker(airport.name, monogram: Text(airport.icao), coordinate: airport.coordinates)
                        .tint(Color.accentColor)
                }
            }
        }
    }
}

#Preview {
    AirportMap()
        .modelContainer(previewContainer)
}
