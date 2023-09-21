//
//  AirportEditor.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import SwiftUI

struct AirportEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var airport: Airport?
    
    @State private var iata: String = ""
    @State private var icao: String = ""
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var country: String = ""
    @State private var latitudeString: String = ""
    @State private var longitudeString: String = ""
    @State private var visited: Bool = false
    @State private var tags: [String] = []
    
    @State private var tagField: String = ""
    
    private var title: String {
        airport == nil ? "New Airport" : "Edit \(airport?.name ?? "")"
    }
    
    private func save() {
        if let airport {
            airport.iata = iata
            airport.icao = icao
            airport.name = name
            airport.location = location
            airport.country = country
            airport.latitude = Double(latitudeString) ?? 0.0
            airport.longitude = Double(longitudeString) ?? 0.0
            airport.visited = visited
            airport.tags = tags
        } else {
            let newAirport = Airport(iata: iata, icao: icao, name: name, location: location, country: country, latitude: Double(latitudeString) ?? 0.0, longitude: Double(longitudeString) ?? 0.0, visited: visited, tags: tags)
            modelContext.insert(newAirport)
        }
    }
    
    private func generateTags() {
        if !iata.isEmpty {
            tags.append(iata)
        }
        
        if !icao.isEmpty {
            tags.append(icao)
        }
        
        if !name.isEmpty {
            tags.append(name)
        }
    }
    
    @State private var showDeleteAlert: Bool = false
    
    @State var airports: [Airport] = []
    @State private var showSearchList: Bool = false
    @State private var searchField: String = ""
    private func list() -> some View {
        return NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Airport Name Search", text: $searchField)
                }.padding()
                List(airports.filter({$0.icao.lowercased().contains(searchField.lowercased())})) { tc in
                    Button {
                        iata = tc.iata
                        icao = tc.icao
                        name = tc.name
                        location = tc.location
                        country = tc.country
                        latitudeString = String(tc.latitude)
                        longitudeString = String(tc.longitude)
                        
                        name = name.replacingOccurrences(of: "International", with: "Intl").replacingOccurrences(of: "Airport", with: "")
                        showSearchList = false
                    } label: {
                        HStack {
                            Text(tc.codes)
                                .font(.subheadline)
                            
                            Text(tc.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        showSearchList = false
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
    
    var body: some View {
        Form {
            Section {
                FormTextField(title: "IATA Code", content: $iata, min: 0, max: 2)
                FormTextField(title: "ICAO Code", content: $icao, min: 1, max: 5)
                FormTextField(title: "Name", content: $name)
                FormTextField(title: "Location", content: $location)
                Toggle(isOn: $visited, label: {
                    Text("Visited this airport")
                })
            }
            
            Section {
                FormTextField(title: "Country", content: $country, min: 1, max: 2)
                FormTextField(title: "Latitude", content: $latitudeString, min: 0)
                FormTextField(title: "Longitude", content: $longitudeString, min: 0)
            }
            
            Section {
                List(tags, id: \.self) { tag in
                    Text(tag)
                        .contextMenu {
                            Button(action: {
                                if let index = tags.firstIndex(of: tag) {
                                    tags.remove(at: index)
                                }
                            }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                        }
                }
                HStack {
                    FormTextField(title: "New Tag", content: $tagField, min: 0)
                    Button {
                        if !tagField.isEmpty {
                            withAnimation {
                                tags.append(tagField)
                                tagField = ""
                            }
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
        .alert("Delete", isPresented: $showDeleteAlert, actions: {
            Button("Yes", role: .destructive) {
                if let airport {
                    modelContext.delete(airport)
                    dismiss()
                }
            }
            
            Button("No", role: .cancel) {
                
            }
        }, message: {
            Text("Are you sure you want to delete \(airport?.name ?? "")")
        })
        .onAppear {
            if let airport {
                iata = airport.iata
                icao = airport.icao
                name = airport.name
                location = airport.location
                country = airport.country
                latitudeString = String(airport.latitude)
                longitudeString = String(airport.longitude)
                visited = airport.visited
                tags = airport.tags
            }
        }
        .sheet(isPresented: $showSearchList, content: {
            list()
        })
        .task {
            airports = await airportFile()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem {
                Button {
                    showSearchList.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            ToolbarItem {
                Button("Auto Generate Tags") {
                    generateTags()
                }
            }
            
            ToolbarItem(placement: .destructiveAction) {
                if let airport {
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .symbolRenderingMode(.multicolor)
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    save()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AirportEditor()
}
