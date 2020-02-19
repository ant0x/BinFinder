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
    var visible = true
}
public var bins = [BinStruct(type: "Paper", latitude: 40.772129, longtitude: 14.790930),
            BinStruct(type: "Glass", latitude: 40.771653, longtitude: 14.794155),
            BinStruct(type: "Plastic & Metals", latitude: 40.767802, longtitude: 14.793168),
            BinStruct(type: "Mixed waste", latitude: 40.774611, longtitude: 14.789757),
            BinStruct(type: "Organic waste", latitude: 40.777341, longtitude: 14.787289),
            BinStruct(type: "Paper", latitude: 40.770231, longtitude: 14.797707)]

