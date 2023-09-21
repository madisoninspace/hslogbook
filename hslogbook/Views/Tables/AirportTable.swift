//
//  AirportTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftCSV
import SwiftData
import SwiftUI

struct AirportTable: View {
    @Environment(\.modelContext) private var modelContext
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
    @State private var showNewEditor: Bool = false
    @State private var showImportAlert: Bool = false
    
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
        .alert("Import Airports", isPresented: $showImportAlert, actions: {
            Button("Yes", role: .destructive) {
                Task {
                    if let path = Bundle.main.path(forResource: "airports", ofType: "csv") {
                        do {
                            let csvFile = try String(contentsOfFile: path)
                            let csv: CSV = try CSV<Named>(string: csvFile)
                            
                            for row in csv.rows {
                                let iata = row["IATA"] ?? ""
                                let icao = row["ICAO"] ?? ""
                                let name = row["Name"] ?? ""
                                let location = row["Location"] ?? ""
                                let country = row["CountryISO2"] ?? ""
                                let latitude = row["Latitude"] ?? ""
                                let longitude = row["Longitude"] ?? ""
                                
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
                                
                                let lat = Double(latitude) ?? 0.0
                                let lon = Double(longitude) ?? 0.0
                                
                                let numRange = icao.rangeOfCharacter(from: .decimalDigits)
                                if numRange != nil {
                                    continue
                                }
                                
                                let newAirport = Airport(iata: iata, icao: icao, name: name, location: location, country: country, latitude: lat, longitude: lon, visited: false, tags: tags)
                                modelContext.insert(newAirport)
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
            Text("Are you sure you want to import the full list of airports?")
        })
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
        .sheet(isPresented: $showEditor, content: {
            if let airport = airports.first(where: {$0.id == tableSelection}) {
                NavigationStack {
                    AirportEditor(airport: airport)
                }
            }
        })
        .sheet(isPresented: $showNewEditor, content: {
            NavigationStack {
                AirportEditor()
            }
        })
        .toolbar {
            ToolbarItem {
                Menu(content: {
                    Button {
                        showImportAlert.toggle()
                    } label: {
                        Label("Import Airports", systemImage: "square.and.arrow.down.on.square")
                    }
                }, label: {
                    Label("Menu", systemImage: "filemenu.and.selection")
                })
            }
            
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
        if airports.first(where: {$0.id == tableSelection}) != nil {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    NavigationStack {
        AirportTable()
            .modelContainer(previewContainer)
    }
}
