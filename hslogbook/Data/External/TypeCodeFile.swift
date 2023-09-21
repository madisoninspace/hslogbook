//
//  TypeCodeFile.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftCSV

func typeCodeFile() async -> [TypeCode] {
    var codes: [TypeCode] = []
    
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
                codes.append(newTypeCode)
            }
        } catch {
            print("CSV File Error")
        }
    } else {
        print("File Error")
    }
    
    return codes
}
