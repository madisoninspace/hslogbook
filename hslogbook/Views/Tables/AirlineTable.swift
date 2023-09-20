//
//  AirlineTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

struct AirlineTable: View {
    @Query(sort: [
            SortDescriptor(\Airline.name)
        ], animation: .smooth) private var airlines: [Airline]
    @State var incomingAirlines: [Airline]? = nil
    private var airlineSelection: [Airline] {
        if let incomingAirlines {
            return incomingAirlines
        } else {
            return airlines
        }
    }
        
    @State private var tableSelection: Airline.ID?
    
    @State private var searchQuery: String = ""
    @State private var searchScope: AirlineSearchScope = .name
    private var filteredAirlines: [Airline] {
        if searchQuery.isEmpty {
            return airlineSelection
        }
        
        let filtered = airlineSelection.compactMap { airline in
            switch searchScope {
                case .iata:
                    let query = airline.iata.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airline : nil
                case .icao:
                    let query = airline.icao.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airline : nil
                case .name:
                    let query = airline.callsign.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airline : nil
                case .callsign:
                    let query = airline.callsign.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airline : nil
            }
        }
        
        return filtered
    }

    var body: some View {
        Table(filteredAirlines, selection: $tableSelection) {
            TableColumn("ICAO") { al in
                NavigationLink(value: al) {
                    Text(al.icao)
                }
            }.width(70.0)
            TableColumn("IATA", value: \.iata)
                .width(70.0)
            TableColumn("Name", value: \.name)
            TableColumn("Callsign", value: \.callsign)
        }
        .navigationDestination(for: Airline.self, destination: { airline in
            AirlineInfo(airline)
        })
        .searchable(text: $searchQuery)
        .searchScopes($searchScope, scopes: {
            Text("IATA")
                .tag(AirlineSearchScope.iata)
            
            Text("ICAO")
                .tag(AirlineSearchScope.icao)
            
            Text("Name")
                .tag(AirlineSearchScope.name)
            
            Text("Callsign")
                .tag(AirlineSearchScope.callsign)
        })
    }
}

#Preview {
    NavigationStack {
        AirlineTable()
            .modelContainer(previewContainer)
    }
}
