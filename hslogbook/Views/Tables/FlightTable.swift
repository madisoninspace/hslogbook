//
//  FlightTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

struct FlightTable: View {
    @Query(sort: [
        SortDescriptor(\Flight.date)
    ], animation: .smooth) private var flights: [Flight]
    @State var incomingFlights: [Flight]? = nil
    private var flightSelection: [Flight] {
        if let incomingFlights {
            return incomingFlights
        } else {
            return flights
        }
    }
    
    @State private var searchQuery: String = ""
    @State private var searchScope: FlightScope = .aircraft
    private var filteredFlights: [Flight] {
        if searchQuery.isEmpty {
            return flightSelection
        }
        
        let filtered = flightSelection.compactMap { flight in
            switch searchScope {
                case .date:
                    let query = flight.dateString.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? flight : nil
                case .flightNo:
                    let query = flight.flightNumber.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? flight : nil
                case .aircraft:
                    let query = flight.aircraft.registration.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? flight : nil
                case .airline:
                    let query = flight.operatedBy?.name.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? flight : nil
                case .origin:
                    let query = flight.origin?.icao.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? flight : nil
                case .destination:
                    let query = flight.destination?.icao.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? flight : nil
            }
        }
        
        return filtered
    }
    
    var body: some View {
        Table(flights) {
            TableColumn("Date") { ac in
                Text(ac.dateString)
                    .fontDesign(.monospaced)
            }.width(110.0)
            TableColumn("Flight") { ac in
                if (ac.operatedBy?.name != "" && ac.flightNumber != "") {
                    Text("\(ac.operatedBy?.name ?? "") \(Text("#").textScale(.secondary))\(ac.flightNumber)")
                }
            }
            TableColumn("Operating For") { ac in
                Text(ac.operatingFor?.name ?? "")
            }
            TableColumn("Destination") { ac in
                Text(ac.origin?.name ?? "")
            }
            TableColumn("Destination") { ac in
                Text(ac.destination?.name ?? "")
            }
        }
        .searchable(text: $searchQuery)
        .searchScopes($searchScope, scopes: {
            ForEach(FlightScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
                    .tag(scope)
            }
        })
    }
}

#Preview {
    FlightTable()
}
