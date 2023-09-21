//
//  Scopes.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation

enum AircraftSearchScope: String, CaseIterable {
    case registration
    case model
    case msn = "Serial Number"
    case airline
    case specialName = "Special Livery"
}

enum AirlineSearchScope: String, CaseIterable {
    case iata
    case icao
    case name
//    case callsign
}

enum AirportSearchScope: String, CaseIterable {
    case iata
    case icao
    case name
    case location
}

enum FlightScope: String, CaseIterable {
    case date
    case flightNo = "Flight Num"
    case aircraft = "Aircraft Reg"
    case airline = "Airline"
    case origin = "Origin"
    case destination = "Destination"
}

enum TypeCodeSearchScope: String, CaseIterable {
    case icao
    case manufacturer
    case model
    case fullModel = "Full Model"
}
