//
//  TypeCode.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class TypeCode {
    var code: String
    var manufacturer: String
    var model: String
    var tags: [String]
    
    @Relationship(deleteRule: .cascade, inverse: \Aircraft.type) var airplanes: [Aircraft]? = []
    
    @Transient var fullModel: String {
        return "\(manufacturer) \(model)"
    }
    
    init(code: String, manufacturer: String, model: String, tags: [String] = []) {
        self.code = code
        self.manufacturer = manufacturer
        self.model = model
        self.tags = tags
    }
}

extension TypeCode: Identifiable {
    public var id: PersistentIdentifier { persistentModelID }
}
