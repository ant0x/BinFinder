//
//  AddBinViewController.swift
//  Bin Finder
//
//  Created by Davide Capuano on 14/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddBinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var pickerView: UIPickerView!
    let type = ["Plastic","Paper","Glass","Mixed Wast","Organic Waste"]
    var lattitude: CLLocationDegrees = 0
    var longtitude: CLLocationDegrees = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        print("latitudine passata -> \(lattitude)")
        print("longitudine passata -> \(longtitude)")
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }

}
