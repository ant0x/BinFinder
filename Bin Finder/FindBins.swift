//
//  BinFinder.swift
//  Bin Finder
//
//  Created by Ciro Maione on 18/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//

import UIKit
import CoreLocation

class FindBins: NSObject {
    
    struct Bin {
        var id: Int
        var lattitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
        var type: String
    }
    
    struct BinRequest: Codable {
        var id: String
        var latitude: String
        var longitude: String
        var type: String
    }
    
    var bins: Array<Bin>
    
    
    override init() {

        bins = Array<Bin>()

        super.init()
        
        
        performRequest()

    }
    
    func performRequest() {
        
        // Create URL
        let url = URL(string: "http://binfinder.altervista.org/findbins.php")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            var res: Array<BinRequest>?
            do {
                res = try JSONDecoder().decode(Array<BinRequest>.self, from: data!)
            } catch {
                print("Error took place\(error).")
            }

            
            for bin in res! {
                self.bins.append(Bin(id: Int(bin.id)!, lattitude: Double(bin.longitude)!, longtitude: Double(bin.longitude)!, type: bin.type))
            }
            
        }
        task.resume()
    }
    
    
    func addBin(bin: Bin) {
        // Create URL
        let url = URL(string: "http://binfinder.altervista.org/addbin.php?latitude=\(bin.lattitude)&longitude=\(bin.longtitude)&type=\(bin.type)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
    
}
