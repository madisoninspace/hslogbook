//
//  Airport.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import MapKit
import SwiftData

@Model
final class Airport {
    var iata: String
    var icao: String
    var name: String
    var location: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var visited: Bool = false
    var tags: [String]
    
    @Relationship(deleteRule: .cascade, inverse: \SpottingLocation.airport) var spottingLocations: [SpottingLocation]? = []
    @Relationship(deleteRule: .nullify, inverse: \Flight.origin) var flightsAsOrigin: [Flight]? = []
    @Relationship(deleteRule: .nullify, inverse: \Flight.destination) var flightsAsDestination: [Flight]? = []
    
    @Transient var coordinates: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    init(iata: String, icao: String, name: String, location: String, latitude: Double, longitude: Double, visited: Bool = false, tags: [String] = []) {
        self.iata = iata
        self.icao = icao
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.visited = visited
        self.tags = tags
    }
}

extension Airport: Identifiable {
    public var id: PersistentIdentifier { persistentModelID }
}
