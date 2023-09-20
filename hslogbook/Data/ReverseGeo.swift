//
//  ReverseGeo.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/18/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import MapKit

func reverseGeo(_ coords: CLLocationCoordinate2D) -> CLPlacemark? {
    let geocoder = CLGeocoder()
    let loc = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
    
    var placemark: CLPlacemark?
    
    geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
        if error != nil {
            return
        }
        
        if let placemarks = placemarks, let pm = placemarks.first {
            placemark = pm
        } else {
            return
        }
    })
    
    if let placemark {
        return placemark
    } else {
        return nil
    }
}
