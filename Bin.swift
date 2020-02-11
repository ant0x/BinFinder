//
//  Bin.swift
//  Bin Finder
//
//  Created by Antonio Baldi on 11/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Bin {
  var type: String?
  var boundary: [CLLocationCoordinate2D] = []
  
  var midCoordinate = CLLocationCoordinate2D()
  var overlayTopLeftCoordinate = CLLocationCoordinate2D()
  var overlayTopRightCoordinate = CLLocationCoordinate2D()
  var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
  var overlayBottomRightCoordinate = CLLocationCoordinate2D()
  
  var overlayBoundingMapRect: MKMapRect?


    

 func plist(_ plist: String) -> Any? {
  let filePath = Bundle.main.path(forResource: plist, ofType: "plist")!
  let data = FileManager.default.contents(atPath: filePath)!
  return try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
}
    
    static func parseCoord(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D {
      guard let coord = dict[fieldName] as? String else {
        return CLLocationCoordinate2D()
      }
        let point = NSCoder.cgPoint(for: coord)
      return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
    }
    
    
    
    
}
