//
//  AirlineSearch.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/21/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirlineSearch: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var iata: String
    @Binding var icao: String
    @Binding var name: String
    
    @State private var airlines: [Airline] = []
    @State private var searchQuery: String = ""
    @State private var searchMode: Int = 0
    
    @State private var selectedAirline: Airline?
    
    private func filter() -> [Airline] {
        switch searchMode {
            case 0:
                return airlines.filter({$0.icao.lowercased().contains(searchQuery.lowercased())})
                
            case 1:
                return airlines.filter({$0.iata.lowercased().contains(searchQuery.lowercased())})
                
            case 2:
                return airlines.filter({$0.name.lowercased().contains(searchQuery.lowercased())})
                
            default:
                return airlines
        }
    }
    
    var body: some View {
        Group {
            if airlines.count == 0 {
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
                        }, label: {
                            Text("Search Type:")
                        })
                        .pickerStyle(.segmented)
                    }.padding(.horizontal, 15.0)
                    
                    List(filter(), id: \.self, selection: $selectedAirline) { airline in
                        HStack(alignment: .center) {
                            Text(airline.codes)
                                .textScale(.secondary)
                                .frame(width: 100.0)
                            
                            Text(airline.name)
                                .font(.headline)
                        }
                    }
                }
            }
        }
        .navigationTitle("Airline Search")
        .task {
            airlines = await airlineFile().sorted(by: {$0.name < $1.name})
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if let ap = selectedAirline {
                        iata = ap.iata
                        icao = ap.icao
                        name = ap.name
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AirlineSearch(iata: .constant("AA"), icao: .constant("AAL"), name: .constant("American"))
}
