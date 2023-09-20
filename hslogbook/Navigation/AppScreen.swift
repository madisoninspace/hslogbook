//
//  AppScreen.swift
//  Gateway
//
//  Created by Hannah Wass on 9/17/23.
//

import Foundation
import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case aircraft
    case airlines
    case airports
    case flights
    case photos
    case typeDesignators
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
            case .aircraft:
                Label("Aircraft", systemImage: "airplane")
            case .airlines:
                Label("Airlines", systemImage: "airplane.departure")
            case .airports:
                Label("Airports", systemImage: "airplane.arrival")
            case .flights:
                Label("Flights", systemImage: "ticket")
            case .photos:
                Label("Photos", systemImage: "photo")
            case .typeDesignators:
                Label("Type Designators", systemImage: "t.square")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .aircraft:
                AircraftCore()
                //ContentUnavailableView("No Aircraft", systemImage: "airplane")
            case .airlines:
                AirlineCore()
                //ContentUnavailableView("No Airlines", systemImage: "airplane.departure")
            case .airports:
                AirportCore()
                //ContentUnavailableView("No Airports", systemImage: "airplane.arrival")
                //Airports()
            case .flights:
                FlightCore()
                //ContentUnavailableView("No Flights", systemImage: "ticket")
            case .photos:
                ContentUnavailableView("No Photos", systemImage: "photo")
            case .typeDesignators:
                TypeCodeCore()
                //ContentUnavailableView("No Type Designators", systemImage: "t.square")
        }
    }
}
