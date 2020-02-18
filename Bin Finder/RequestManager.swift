//
//  RequestManager.swift
//  Bin Finder
//
//  Created by Ciro Maione on 18/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    let FIND_BINS = "http://binfinder.altervista.org/findbins.php"

    func makeGetCall() {
          // Set up the URL request
          let todoEndpoint: String = FIND_BINS
          guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
          }
          let urlRequest = URLRequest(url: url)

          // set up the session
          let config = URLSessionConfiguration.default
          let session = URLSession(configuration: config)

          // make the request
          let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
              print("error calling GET on /todos/1")
              print(error!)
              return
            }
            // make sure we got data
            guard let responseData = data else {
              print("Error: did not receive data")
              return
            }
            do {
   
                if let jsonData = data {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                        

                    }
                }
                
            } catch  {
              print("error trying to convert data to JSON")
              return
            }
          }
          task.resume()
        }
}
