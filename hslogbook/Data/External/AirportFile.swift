//
//  AirportFile.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftCSV

func airportFile() async -> [Airport] {
    var airports: [Airport] = []
    
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
                airports.append(newAirport)
            }
        } catch {
            print("CSV File Error")
        }
    } else {
        print("File Error")
    }
    
    return airports
}
