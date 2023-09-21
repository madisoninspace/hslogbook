//
//  AirlineFile.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftCSV

func airlineFile() async -> [Airline] {
    var airlines: [Airline] = []
    
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
                airlines.append(newAirline)
            }
        } catch {
            print("CSV File Error")
        }
    } else {
        print("File Error")
    }
    
    return airlines
}
