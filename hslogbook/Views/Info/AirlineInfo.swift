//
//  AirlineInfo.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirlineInfo: View {
    @Bindable var airline: Airline
    
    init(_ airline: Airline) {
        self.airline = airline
    }
    
    var body: some View {
        TabView {
            AircraftTable(incomingAircraft: airline.airplanes)
                .tabItem { Label("Aircraft", systemImage: "airplane") }
            
            FlightTable(incomingFlights: airline.flightsOperatedBy)
                .tabItem { Label("Flights By", systemImage: "ticket") }
            
            FlightTable(incomingFlights: airline.flightsOperatingFor)
                .tabItem { Label("Flights For", systemImage: "f.square") }
        }
        .navigationTitle(airline.name)
    }
}

#Preview {
    NavigationStack {
        AirlineInfo(Airline(iata: "AA", icao: "AAL", name: "American Airlines", remarks: ""))
    }
}
