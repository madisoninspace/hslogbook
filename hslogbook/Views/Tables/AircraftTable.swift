//
//  AircraftTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

struct AircraftTable: View {
    @Query(sort: [
        SortDescriptor(\Aircraft.type.manufacturer),
        SortDescriptor(\Aircraft.model),
        SortDescriptor(\Aircraft.registration)
    ], animation: .smooth) private var airplanes: [Aircraft]
    @State var incomingAircraft: [Aircraft]? = nil
    private var aircraftSelection: [Aircraft] {
        if let incomingAircraft {
            return incomingAircraft
        } else {
            return airplanes
        }
    }
    
    @State private var tableSelection: Airport.ID?
    
    @State private var searchQuery: String = ""
    @State private var searchScope: AircraftSearchScope = .registration
    private var filteredAirplanes: [Aircraft] {
        if searchQuery.isEmpty {
            return aircraftSelection
        }
        
        let filtered = aircraftSelection.compactMap { airplane in
            switch searchScope {
                case .registration:
                    let query = airplane.registration.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airplane : nil
                case .model:
                    let query = airplane.model.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airplane : nil
                case .msn:
                    let query = airplane.msn.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airplane : nil
                case .airline:
                    let query = airplane.airline?.name.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airplane : nil
                case .specialName:
                    let query = airplane.specialLiveryName.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airplane : nil
            }
        }
        
        return filtered
    }
    
    var body: some View {
        Table(filteredAirplanes, selection: $tableSelection) {
            TableColumn("Registration", value: \.registration)
                .width(100.0)
            TableColumn("Mfg/Model", value: \.fullModel)
                .width(275.0)
            TableColumn("Serial Numbers", value: \.serialNumbers)
                .width(180.0)
            TableColumn("Airline") { ac in
                if ac.airline != nil {
                    NavigationLink(value: ac.airline) {
                        Text("\(ac.airline?.name ?? "") \(Text(ac.airline?.codes ?? "").textScale(.secondary))")
                    }
                }
            }
            TableColumn("S/L") { ac in
                if ac.specialLivery {
                    Image(systemName: "s.circle")
                }
            }.width(60.0)
        }
        .navigationDestination(for: Airline.self, destination: { airline in
            AirlineInfo(airline)
        })
        .navigationDestination(for: TypeCode.self, destination: { typeCode in
            
        })
        .searchable(text: $searchQuery)
        .searchScopes($searchScope, scopes: {
            ForEach(AircraftSearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
                    .tag(scope)
            }
        })
    }
}

#Preview {
    NavigationStack {
        AircraftTable()
            .modelContainer(previewContainer)
    }
}
