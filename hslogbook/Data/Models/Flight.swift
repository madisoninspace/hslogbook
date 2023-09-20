//
//  Flight.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Flight {
    var date: Date
    var aircraft: Aircraft
    var operatedBy: Airline? = nil
    var operatingFor: Airline? = nil
    var origin: Airport? = nil
    var destination: Airport? = nil
    var otherLocation: String
    var spottedAt: SpottedAt
    var spottingLocation: SpottingLocation? = nil
    var flightNumber: String
    var remarks: String
    @Attribute(.externalStorage) var photos: [Data]? = []
    
    @Transient var dateString: String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/YYYY"
        
        return df.string(from: date)
    }
    
    init(date: Date, aircraft: Aircraft, operatedBy: Airline?, operatingFor: Airline?, origin: Airport?, destination: Airport?, otherLocation: String, spottedAt: SpottedAt, spottingLocation: SpottingLocation?, flightNumber: String, remarks: String) {
        self.date = date
        self.aircraft = aircraft
        self.operatedBy = operatedBy
        self.operatingFor = operatingFor
        self.origin = origin
        self.destination = destination
        self.otherLocation = otherLocation
        self.spottedAt = spottedAt
        self.spottingLocation = spottingLocation
        self.flightNumber = flightNumber
        self.remarks = remarks
    }
}

enum SpottedAt: Int, Codable {
    case origin = 0
    case destination = 1
    case contrail = 2
    case otherLocation = 3
    case museum = 4
    case unknown = 99
}

extension Flight: Identifiable {
    public var id: PersistentIdentifier { persistentModelID }
}
