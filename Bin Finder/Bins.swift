//
//  Bins.swift
//  Bin Finder
//
//  Created by Antonio Baldi on 18/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//

import Foundation
import CoreLocation
public struct BinStruct {
    var type: String
    var latitude: CLLocationDegrees
    var longtitude: CLLocationDegrees
}
public var bins = [BinStruct(type: "Paper", latitude: 40.7723, longtitude: 14.7899),
            BinStruct(type: "Glass", latitude: 41.7723, longtitude: 15.7899),
            BinStruct(type: "Plastic & Metals", latitude: 42.7723, longtitude: 16.7899),
            BinStruct(type: "Mixed waste", latitude: 39.7723, longtitude: 13.7899),
            BinStruct(type: "Organic waste", latitude: 43.7723, longtitude: 14.7899),
            BinStruct(type: "Paper", latitude: 40.7723, longtitude: 11.7899)]
