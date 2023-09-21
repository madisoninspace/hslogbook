//
//  AirlineEditor.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct AirlineEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var airline: Airline?
    
    @State private var iata: String = ""
    @State private var icao: String = ""
    @State private var name: String = ""
//    @State private var callsign: String = ""
//    @State private var country: String = ""
    @State private var remarks: String = ""
    @State private var tags: [String] = []
    
    @State private var tagField: String = ""
    
    private var title: String {
        airline == nil ? "New Airline" : "Edit \(airline?.name ?? "")"
    }
    
    private func save() {
        if let airline {
            airline.iata = iata
            airline.icao = icao
            airline.name = name
//            airline.callsign = callsign
//            airline.country = country
            airline.remarks = remarks
            airline.tags = tags
        } else {
            let newAirline = Airline(iata: iata, icao: icao, name: name, remarks: remarks, tags: tags)
            modelContext.insert(newAirline)
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
        
//        if !callsign.isEmpty {
//            tags.append(callsign)
//        }
    }
    
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        Form {
            Section {
                FormTextField(title: "IATA Code", content: $iata, min: 0, max: 2)
                FormTextField(title: "ICAO Code", content: $icao, min: 1, max: 4)
                FormTextField(title: "Name", content: $name)
//                FormTextField(title: "Callsign", content: $callsign)
//                FormTextField(title: "Country", content: $country, min: 1, max: 2)
            }
            
            Section(content: {
                TextEditor(text: $remarks)
            }, header: {
                Text("Remarks")
            })
            
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
                if let airline {
                    modelContext.delete(airline)
                    dismiss()
                }
            }
            
            Button("No", role: .cancel) {
                
            }
        }, message: {
            Text("Are you sure you want to delete \(airline?.name ?? "")")
        })
        .onAppear {
            if let airline {
                iata = airline.iata
                icao = airline.icao
                name = airline.name
//                callsign = airline.callsign
//                country = airline.country
                remarks = airline.remarks
                
                if airline.tags.count > 0 {
                    for tag in airline.tags {
                        tags.append(tag)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem {
                Button("Auto Generate Tags") {
                    generateTags()
                }
            }
            
            ToolbarItem(placement: .destructiveAction) {
                if let airline {
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AirlineEditor()
}
