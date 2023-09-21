//
//  PreviewContainer.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftData
import Foundation

@MainActor
var previewContainer: ModelContainer = {
    let schema = Schema([
        Aircraft.self,
        Airline.self,
        Airport.self,
        Flight.self,
        SpottingLocation.self,
        TypeCode.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        
        let sampleAirline = Airline(iata: "AA", icao: "AAL", name: "American Airlines", remarks: "")
        let sampleTypeCode = TypeCode(code: "A321", manufacturer: "Airbus", model: "A321")
        let sampleAircraft = Aircraft(registration: "N582UW", type: sampleTypeCode, model: "A321-231", msn: "6175", ln: "", airline: sampleAirline, fleetName: "", fleetNumber: "582", specialLivery: true, specialLiveryName: "PSA Heritage", remarks: "")
        let sampleOrigin = Airport(iata: "DFW", icao: "KDFW", name: "Dallas-Fort Worth Intl", location: "Dallas, Texas", latitude: 32.896944, longitude: -97.038056)
        let sampleDestination = Airport(iata: "CMH", icao: "KCMH", name: "John Glenn Columbus Intl", location: "Columbus, Ohio", latitude: 39.998056, longitude: -82.891944, visited: true)
        let sampleSpottingLocation = SpottingLocation(airport: sampleDestination, name: "Parking Garage", latitude: 39.99815, longitude: -82.88621)
        let sampleFlight = Flight(date: Date(), aircraft: sampleAircraft, operatedBy: sampleAirline, operatingFor: nil, origin: sampleOrigin, destination: sampleDestination, otherLocation: "", spottedAt: .destination, spottingLocation: sampleSpottingLocation, flightNumber: "1492", remarks: "")
        
        let sampleTypeCode2 = TypeCode(code: "B38M", manufacturer: "Boeing", model: "737 MAX 8")
        let samplePlane2 = Aircraft(registration: "N316SE", type: sampleTypeCode2, model: "737 MAX 8", msn: "44472", ln: "7481", airline: sampleAirline, fleetName: "", fleetNumber: "3SE", specialLivery: false, specialLiveryName: "", remarks: "")
        
        container.mainContext.insert(sampleAirline)
        container.mainContext.insert(sampleTypeCode)
        container.mainContext.insert(sampleAircraft)
        container.mainContext.insert(sampleOrigin)
        container.mainContext.insert(sampleDestination)
        container.mainContext.insert(sampleSpottingLocation)
        container.mainContext.insert(sampleFlight)
        
        container.mainContext.insert(sampleTypeCode2)
        container.mainContext.insert(samplePlane2)
        
        return container
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
