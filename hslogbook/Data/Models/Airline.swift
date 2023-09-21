//
//  Airline.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Airline {
    var iata: String
    var icao: String
    var name: String
//    var callsign: String
//    var country: String
    var remarks: String
    var tags: [String]
    
    @Relationship(deleteRule: .nullify, inverse: \Aircraft.airline) var airplanes: [Aircraft]? = []
    @Relationship(deleteRule: .nullify, inverse: \Flight.operatedBy) var flightsOperatedBy: [Flight]? = []
    @Relationship(deleteRule: .nullify, inverse: \Flight.operatingFor) var flightsOperatingFor: [Flight]? = []
    
    @Transient var codes: String {
        if iata.isEmpty {
            return icao
        } else {
            return "\(iata)/\(icao)"
        }
    }
    
    init(iata: String, icao: String, name: String, remarks: String, tags: [String] = []) {
        self.iata = iata
        self.icao = icao
        self.name = name
//        self.callsign = callsign
//        self.country = country
        self.remarks = remarks
        self.tags = tags
    }
}

extension Airline: Identifiable {
    public var id: PersistentIdentifier { persistentModelID }
}
