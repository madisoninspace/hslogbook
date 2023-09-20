//
//  AirportTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

struct AirportTable: View {
    @Query(sort: [
        SortDescriptor(\Airport.icao),
        SortDescriptor(\Airport.name)
    ], animation: .spring) private var airports: [Airport]
    @State var incomingAirports: [Airport]? = nil
    private var airportSelection: [Airport] {
        if let incomingAirports {
            return incomingAirports
        } else {
            return airports
        }
    }
    
    @State private var tableSelection: Airport.ID?
    
    @State private var searchQuery: String = ""
    @State private var searchScope: AirportSearchScope = .icao
    private var filteredAirports: [Airport] {
        if searchQuery.isEmpty {
            return airportSelection
        }
        
        let filtered = airportSelection.compactMap { airport in
            switch searchScope {
                case .iata:
                    let query = airport.iata.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airport : nil
                case .icao:
                    let query = airport.icao.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airport : nil
                case .name:
                    let query = airport.name.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airport : nil
                case .location:
                    let query = airport.location.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airport : nil
            }
        }
        
        return filtered
    }
    
    @State private var hideUnvisitedAirports: Bool = false
    @State private var showEditor: Bool = false
    
    private var huAirports: [Airport] {
        if hideUnvisitedAirports {
            return filteredAirports.filter({ $0.visited == true })
        } else {
            return filteredAirports
        }
    }
    
    var body: some View {
        Table(huAirports, selection: $tableSelection) {
            TableColumn("ICAO", value: \.icao)
                .width(70.0)
            TableColumn("IATA", value: \.iata)
                .width(70.0)
            TableColumn("Name", value: \.name)
            TableColumn("Location", value: \.location)
            TableColumn("Visited") { ap in
                if ap.visited {
                    Image(systemName: "checkmark")
                }
            }.width(50.0)
        }
        .modifier(GWToolbarRole(title: "Airports"))
        .searchable(text: $searchQuery)
        .searchScopes($searchScope) {
            Text("IATA Code")
                .tag(AirportSearchScope.iata)
            
            Text("ICAO Code")
                .tag(AirportSearchScope.icao)
            
            Text("Name")
                .tag(AirportSearchScope.name)
            
            Text("Location")
                .tag(AirportSearchScope.location)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle(isOn: $hideUnvisitedAirports.animation(.spring), label: {
                    switch hideUnvisitedAirports {
                        case true:
                            Image(systemName: "eye")
                            
                        case false:
                            Image(systemName: "eye.slash")
                    }
                }).padding(.trailing)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AirportTable()
            .modelContainer(previewContainer)
    }
}
