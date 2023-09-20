//
//  Aircraft.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Aircraft {
    var registration: String
    var type: TypeCode
    var model: String
    var msn: String
    var ln: String
    var airline: Airline? = nil
    var fleetName: String
    var fleetNumber: String
    var specialLivery: Bool = false
    var specialLiveryName: String
    var remarks: String
    var tags: [String]
    
    @Relationship(deleteRule: .deny, inverse: \Flight.aircraft) var flights: [Flight]? = []
    
    @Transient var fullModel: String {
        return "\(type.manufacturer) \(model)"
    }
    
    @Transient var serialNumbers: String {
        if ln.isEmpty {
            return msn
        } else {
            return "\(msn)/\(ln)"
        }
    }
    
    init(registration: String, type: TypeCode, model: String, msn: String, ln: String, airline: Airline? = nil, fleetName: String, fleetNumber: String, specialLivery: Bool, specialLiveryName: String, remarks: String, tags: [String] = []) {
        self.registration = registration
        self.type = type
        self.model = model
        self.msn = msn
        self.ln = ln
        self.airline = airline
        self.fleetName = fleetName
        self.fleetNumber = fleetNumber
        self.specialLivery = specialLivery
        self.specialLiveryName = specialLiveryName
        self.remarks = remarks
        self.tags = tags
    }
}

extension Aircraft: Identifiable {
    public var id: PersistentIdentifier { persistentModelID }
}
