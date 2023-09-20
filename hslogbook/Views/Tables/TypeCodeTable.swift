//
//  TypeCodeTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

struct TypeCodeTable: View {
    @StateObject var path = Path.shared
    
    @Query(sort: [
        SortDescriptor(\TypeCode.manufacturer),
        SortDescriptor(\TypeCode.model),
    ], animation: .smooth) private var codes: [TypeCode]
    @State var incomingTypeCodes: [TypeCode]? = nil
    
    private var codeSelection: [TypeCode] {
        if let incomingTypeCodes {
            return incomingTypeCodes
        } else {
            return codes
        }
    }
    
    @State private var searchQuery: String = ""
    @State private var searchScope: TypeCodeSearchScope = .fullModel
    private var filteredCodes: [TypeCode] {
        if searchQuery.isEmpty {
            return codeSelection
        }
        
        let filtered = codeSelection.compactMap { code in
            switch searchScope {
                case .icao:
                    let query = code.code.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? code : nil
                case .manufacturer:
                    let query = code.manufacturer.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? code : nil
                case .model:
                    let query = code.model.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? code : nil
                case .fullModel:
                    let query = code.fullModel.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? code : nil
            }
        }
        
        return filtered
    }
    
    @State private var tableSelection: TypeCode.ID?
    
    var body: some View {
        Table(filteredCodes, selection: $tableSelection) {
            TableColumn("Code") { tc in
                NavigationLink(value: tc) {
                    Text(tc.code)
                }
            }.width(85.0)
            TableColumn("Manufacturer", value: \.manufacturer)
            TableColumn("Model", value: \.model)
            TableColumn("Ct.") { tc in
                Text("\(tc.airplanes?.count ?? 0)")
            }.width(60.0)
        }
        .navigationDestination(for: TypeCode.self, destination: { ac in
            if let planes = ac.airplanes {
                AircraftTable(incomingAircraft: planes)
                    .navigationTitle(ac.fullModel)
            } else {
                ContentUnavailableView("No Aircraft", systemImage: "airplane", description: Text("No aircraft for this type code."))
            }
        })
        .searchable(text: $searchQuery)
        .searchScopes($searchScope, scopes: {
            Text("ICAO Code")
                .tag(TypeCodeSearchScope.icao)
            
            Text("Manufacturer")
                .tag(TypeCodeSearchScope.manufacturer)
            
            Text("Model")
                .tag(TypeCodeSearchScope.model)
            
            Text("Mfg/Model")
                .tag(TypeCodeSearchScope.fullModel)
        })
    }
}

#Preview {
    NavigationSplitView {
        
    } detail: {
        TypeCodeTable()
            .modelContainer(previewContainer)
    }
}
