//
//  SpottingLocation.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import MapKit
import SwiftData

@Model
final class SpottingLocation {
    var airport: Airport
    var name: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @Relationship(deleteRule: .nullify, inverse: \Flight.spottingLocation) var flights: [Flight]? = []
    
    @Transient var coordinates: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    @Transient var location: CLPlacemark? {
        reverseGeo(coordinates)
    }
    
    init(airport: Airport, name: String, latitude: Double, longitude: Double) {
        self.airport = airport
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension SpottingLocation: Identifiable {
    public var id: PersistentIdentifier { persistentModelID }
}
