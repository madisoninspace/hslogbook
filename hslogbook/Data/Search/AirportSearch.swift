//
//  AirportSearch.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirportSearch: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var iata: String
    @Binding var icao: String
    @Binding var name: String
    @Binding var location: String
    @Binding var country: String
    @Binding var latitude: String
    @Binding var longitude: String
    
    @State private var airports: [Airport] = []
    @State private var searchQuery: String = ""
    @State private var searchMode: Int = 0
    
    @State private var selectedAirport: Airport?
    
    private func filter() -> [Airport] {
        switch searchMode {
            case 0:
                return airports.filter({$0.icao.lowercased().contains(searchQuery.lowercased())})
                
            case 1:
                return airports.filter({$0.iata.lowercased().contains(searchQuery.lowercased())})
                
            case 2:
                return airports.filter({$0.name.lowercased().contains(searchQuery.lowercased())})
                
            case 3:
                return airports.filter({$0.location.lowercased().contains(searchQuery.lowercased())})
                
            default:
                return airports
        }
    }
    
    var body: some View {
        Group {
            if airports.count == 0 {
                ProgressView("Loading...")
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Search", text: $searchQuery)
                            .textFieldStyle(.roundedBorder)
                        
                        Picker(selection: $searchMode, content: {
                            Text("ICAO")
                                .tag(0)
                            
                            Text("IATA")
                                .tag(1)
                            
                            Text("Name")
                                .tag(2)
                            
                            Text("Location")
                                .tag(3)
                        }, label: {
                            Text("Search Type:")
                        })
                        .pickerStyle(.segmented)
                    }.padding(.horizontal, 15.0)
                    
                    List(filter(), id: \.self, selection: $selectedAirport) { airport in
                        HStack(alignment: .center) {
                            Text(airport.codes)
                                .textScale(.secondary)
                                .frame(width: 100.0)
                            
                            VStack(alignment: .leading) {
                                Text(airport.name)
                                    .font(.headline)
                                
                                Text("\(airport.location), \(airport.country)")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Airport Search")
        .task {
            airports = await airportFile().sorted(by: {$0.icao < $1.icao})
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if let ap = selectedAirport {
                        iata = ap.iata
                        icao = ap.icao
                        name = ap.name
                        location = ap.location
                        country = ap.country
                        latitude = String(ap.latitude)
                        longitude = String(ap.longitude)
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AirportSearch(iata: .constant("CMH"), icao: .constant("KCMH"), name: .constant("John Glenn Columbus Intl"),
                      location: .constant("Columbus, OH"), country: .constant("US"), latitude: .constant("40.00"), longitude: .constant("-82.00"))
    }
}
