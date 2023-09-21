//
//  AirlineTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftCSV
import SwiftData
import SwiftUI

struct AirlineTable: View {
    @Environment(\.modelContext) private var modelContext
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
                    let query = airline.name.range(of: searchQuery, options: .caseInsensitive) != nil
                    return query ? airline : nil
//                case .callsign:
//                    let query = airline.callsign.range(of: searchQuery, options: .caseInsensitive) != nil
//                    return query ? airline : nil
            }
        }
        
        return filtered
    }
    
    @State private var showEditor: Bool = false
    @State private var showNewEditor: Bool = false
    @State private var showImportAlert: Bool = false

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
            TableColumn("Aircraft") { tc in
                Text("\(tc.airplanes?.count ?? 0)")
            }.width(70.0)
            TableColumn("Flights") { tc in
                Text("\((tc.flightsOperatedBy?.count ?? 0) + (tc.flightsOperatingFor?.count ?? 0))")
            }.width(70.0)
        }
        .alert("Import Airlines", isPresented: $showImportAlert, actions: {
            Button("Yes", role: .destructive) {
                Task {
                    if let path = Bundle.main.path(forResource: "airlines", ofType: "csv") {
                        do {
                            let csvFile = try String(contentsOfFile: path)
                            let csv: CSV = try CSV<Named>(string: csvFile)
                            
                            for row in csv.rows {
                                let iata = row["IATA"] ?? ""
                                let icao = row["ICAO"] ?? ""
                                let name = row["Name"] ?? ""
                                
                                var tags: [String] = []
                                if !iata.isEmpty {
                                    tags.append(iata)
                                }
                                
                                if !icao.isEmpty {
                                    tags.append(icao)
                                }
                                
                                if !name.isEmpty {
                                    tags.append(name)
                                }
                                
                                let newAirline = Airline(iata: iata, icao: icao, name: name, remarks: "", tags: tags)
                                modelContext.insert(newAirline)
                            }
                        } catch {
                            print("CSV File Error")
                        }
                    } else {
                        print("File Error")
                    }
                }
            }
            
            Button("No", role: .cancel) { }
        }, message: {
            Text("Are you sure you want to import the full list of airlines?")
        })
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
            
//            Text("Callsign")
//                .tag(AirlineSearchScope.callsign)
        })
        .sheet(isPresented: $showEditor, content: {
            if let airline = airlines.first(where: {$0.id == tableSelection}) {
                NavigationStack {
                    AirlineEditor(airline: airline)
                }
            }
        })
        .sheet(isPresented: $showNewEditor, content: {
            NavigationStack {
                AirlineEditor()
            }
        })
        .toolbar {
//            ToolbarItem {
//                Menu(content: {
//                    Button {
//                        showImportAlert.toggle()
//                    } label: {
//                        Label("Import Airlines", systemImage: "square.and.arrow.down.on.square")
//                    }
//                }, label: {
//                    Label("Menu", systemImage: "filemenu.and.selection")
//                })
//            }
            
            ToolbarItem {
                Button {
                    showEditor.toggle()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(isSelected())
            }
            
            
            ToolbarItem {
                Button {
                    showNewEditor.toggle()
                } label: {
                    Label("New", systemImage: "plus")
                }
            }
        }
    }
    
    private func isSelected() -> Bool {
        if airlines.first(where: {$0.id == tableSelection}) != nil {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    NavigationStack {
        AirlineTable()
            .modelContainer(previewContainer)
    }
}
