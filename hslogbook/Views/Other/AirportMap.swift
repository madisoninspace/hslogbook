//
//  AirportMap.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Algorithms
import IsoCountryCodes
import MapKit
import SwiftData
import SwiftUI

struct AirportMap: View {
    @Query(sort: [
        SortDescriptor(\Airport.icao),
        SortDescriptor(\Airport.name)
    ], animation: .spring) private var airports: [Airport]
    
    @State private var country: String = "ALLAIRPORTS"
    
    private func markerColor(_ visited: Bool) -> Color {
        if visited {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    private func airportList() -> [Airport] {
        switch country {
            case "ALLAIRPORTS":
                return airports
                
            case "VISITED":
                return airports.filter({$0.visited == true})
                
            default:
                return airports.filter({$0.country == country})
        }
    }
    
    var body: some View {
        Map {
            ForEach(airportList()) { airport in
                if airport.latitude != 0.0 && airport.longitude != 0.0 {
                    Marker(airport.name, monogram: Text(airport.icao), coordinate: airport.coordinates)
                        .tint(markerColor(airport.visited))
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Picker(selection: $country, content: {
                    Text("All Airports")
                        .tag("ALLAIRPORTS")
                    
                    Text("Visited Only")
                        .tag("VISITED")
                    
                    Divider()
                    
                    ForEach(IsoCountries.allCountries, id: \.alpha2) { c in
                        Text(c.name)
                            .tag(c.alpha2)
                    }
                }, label: {
                    
                }).pickerStyle(MenuPickerStyle())
            }
        }
    }
}

#Preview {
    AirportMap()
        .modelContainer(previewContainer)
}
