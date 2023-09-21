//
//  TypeCodeSearch.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/21/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct TypeCodeSearch: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var code: String
    @Binding var manufacturer: String
    @Binding var model: String
    
    @State private var codes: [TypeCode] = []
    @State private var searchQuery: String = ""
    @State private var searchMode: Int = 2
    
    @State private var selectedCode: TypeCode?
    
    private func filter() -> [TypeCode] {
        switch searchMode {
            case 0:
                return codes.filter({$0.code.lowercased().contains(searchQuery.lowercased())})
                
            case 1:
                return codes.filter({$0.manufacturer.lowercased().contains(searchQuery.lowercased())})
                
            case 2:
                return codes.filter({$0.model.lowercased().contains(searchQuery.lowercased())})
                
            default:
                return codes
        }
    }
    
    var body: some View {
        Group {
            if codes.count == 0 {
                ProgressView("Loading...")
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Search", text: $searchQuery)
                            .textFieldStyle(.roundedBorder)
                        
                        Picker(selection: $searchMode, content: {
                            Text("ICAO Code")
                                .tag(0)
                            
                            Text("Manufacturer")
                                .tag(1)
                            
                            Text("Model")
                                .tag(2)
                        }, label: {
                            Text("Search Type:")
                        })
                        .pickerStyle(.segmented)
                    }.padding(.horizontal, 15.0)
                    
                    List(filter(), id: \.self, selection: $selectedCode) { code in
                        HStack(alignment: .center) {
                            Text(code.code)
                                .textScale(.secondary)
                                .frame(width: 100.0)
                            
                            Text(code.fullModel)
                                .font(.headline)
                        }
                    }
                }
            }
        }
        .navigationTitle("Type Code Search")
        .task {
            codes = await typeCodeFile().sorted(by: {$0.model < $1.model})
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if let cd = selectedCode {
                        code = cd.code
                        manufacturer = cd.manufacturer
                        model = cd.model
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TypeCodeSearch(code: .constant("BCS1"), manufacturer: .constant("Airbus"), model: .constant("A220-100"))
}
