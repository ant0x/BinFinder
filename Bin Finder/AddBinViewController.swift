//
//  AddBinViewController.swift
//  Bin Finder
//
//  Created by Davide Capuano on 14/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//

import UIKit

class AddBinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var pickerView: UIPickerView!
    let colors = ["Plastic","Paper","Glass","Mixed Wast","Organic Waste"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
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
