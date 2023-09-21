//
//  TypeCodeEditor.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct TypeCodeEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var typeCode: TypeCode?
    
    @State private var code: String = ""
    @State private var manufacturer: String = ""
    @State private var model: String = ""
    @State private var tags: [String] = []
    
    @State private var tagField: String = ""
    
    private var title: String {
        typeCode == nil ? "New Type Code" : "Edit \(typeCode?.fullModel ?? "")"
    }
    
    private func save() {
        if let typeCode {
            typeCode.code = code
            typeCode.manufacturer = manufacturer
            typeCode.model = model
            typeCode.tags = tags
        } else {
            let newTypeCode = TypeCode(code: code, manufacturer: manufacturer, model: model, tags: tags)
            modelContext.insert(newTypeCode)
        }
    }
    
    private func generateTags() {
        if !code.isEmpty {
            tags.append(code)
        }
        
        if !manufacturer.isEmpty && !model.isEmpty {
            tags.append(manufacturer)
            tags.append(model)
            tags.append("\(manufacturer) \(model)")
        }
    }
    
    @State private var showDeleteAlert: Bool = false
    @State private var showSearch: Bool = false
    
    var body: some View {
        Form {
            Section {
                FormTextField(title: "ICAO Code", content: $code, min: 1, max: 4)
                FormTextField(title: "Manufacturer", content: $manufacturer)
                FormTextField(title: "Model", content: $model)
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
                if let typeCode {
                    modelContext.delete(typeCode)
                    dismiss()
                }
            }
            
            Button("No", role: .cancel) {
                
            }
        }, message: {
            Text("Are you sure you want to delete \(typeCode?.fullModel ?? "")")
        })
        .onAppear {
            if let typeCode {
                code = typeCode.code
                manufacturer = typeCode.manufacturer
                model = typeCode.model
                
                if typeCode.tags.count > 0 {
                    for tag in typeCode.tags {
                        tags.append(tag)
                    }
                }
            }
        }
        .sheet(isPresented: $showSearch, content: {
            NavigationStack {
                TypeCodeSearch(code: $code, manufacturer: $manufacturer, model: $model)
            }
        })
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem {
                Button {
                    showSearch.toggle()
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
                if let typeCode {
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
    NavigationStack {
        TypeCodeEditor()
            .modelContainer(previewContainer)
    }
}
