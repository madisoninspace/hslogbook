//
//  TypeCodeTable.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftCSV
import SwiftData
import SwiftUI

struct TypeCodeTable: View {
    @Environment(\.modelContext) private var modelContext
    
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
    @State private var showEditor: Bool = false
    @State private var showNewEditor: Bool = false
    @State private var showImportAlert: Bool = false
    
    @State private var hideTypesWithNoAircraft: Bool = false
    private func hideTypes() -> [TypeCode] {
        if hideTypesWithNoAircraft {
            return filteredCodes.filter({$0.airplanes?.count ?? 0 > 0})
        } else {
            return filteredCodes
        }
    }
    
    var body: some View {
        Table(hideTypes(), selection: $tableSelection) {
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
        .alert("Import Type Codes", isPresented: $showImportAlert, actions: {
            Button("Yes", role: .destructive) {
                Task {
                    if let path = Bundle.main.path(forResource: "doc8643", ofType: "csv") {
                        do {
                            let csvFile = try String(contentsOfFile: path)
                            let csv: CSV = try CSV<Named>(string: csvFile)
                            
                            for row in csv.rows {
                                let code = row["Designator"] ?? ""
                                let manufacturer = row["ManufacturerCode"] ?? ""
                                let model = row["ModelFullName"] ?? ""
                                var tags: [String] = []
                                
                                if !code.isEmpty {
                                    tags.append(code)
                                }
                                
                                if !manufacturer.isEmpty && !model.isEmpty {
                                    tags.append(manufacturer)
                                    tags.append(model)
                                    tags.append("\(manufacturer) \(model)")
                                }
                                
                                let newTypeCode = TypeCode(code: code, manufacturer: manufacturer, model: model, tags: tags)
                                modelContext.insert(newTypeCode)
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
            Text("Are you sure you want to import the full list of type codes?")
        })
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
        .sheet(isPresented: $showEditor, content: {
            if let code = codes.first(where: {$0.id == tableSelection}) {
                NavigationStack {
                    TypeCodeEditor(typeCode: code)
                }
            }
        })
        .sheet(isPresented: $showNewEditor, content: {
            NavigationStack {
                TypeCodeEditor()
            }
        })
        .toolbar {
            ToolbarItem {
                Menu(content: {
                    Button {
                        showImportAlert.toggle()
                    } label: {
                        Label("Import Type Codes", systemImage: "square.and.arrow.down.on.square")
                    }
                }, label: {
                    Label("Menu", systemImage: "filemenu.and.selection")
                })
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
            
            ToolbarItem(placement: .topBarTrailing) {
                Toggle(isOn: $hideTypesWithNoAircraft.animation(.spring), label: {
                    switch hideTypesWithNoAircraft {
                        case true:
                            Image(systemName: "eye")
                            
                        case false:
                            Image(systemName: "eye.slash")
                    }
                }).padding(.trailing)
            }
        }
    }
    
    private func isSelected() -> Bool {
        if codes.first(where: {$0.id == tableSelection}) != nil {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    NavigationSplitView {
        
    } detail: {
        TypeCodeTable()
            .modelContainer(previewContainer)
    }
}
