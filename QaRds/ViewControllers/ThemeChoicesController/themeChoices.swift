//
//  themeChoices.swift
//  QaRds
//
//  Created by Clifford Yin on 6/23/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseThemeDelegate {
    func chooseTheme(chosenTheme: Int)
}
// In the popover view, this class implements the theme-picker device
class themeChoices: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var delegate2: ChooseThemeDelegate!
    
    @IBOutlet weak var themePicker: UIPickerView!
    
    // List of colors available
    let pickerData = ["", "Red", "Blue", "Green", "Gray", "Purple", "Orange", "Yellow"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.themePicker.delegate = self
        self.themePicker.dataSource = self
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Theme-picking for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // The parameters of row and component represent the data locations
        let theme = themePicker.selectedRow(inComponent: 0)
        delegate2.chooseTheme(chosenTheme: theme)
        
        if (row == 0) {
            themePicker.backgroundColor = .clear
        } else if (row == 1) {
            themePicker.backgroundColor = UIColor(red: 208/255, green: 29/255, blue: 0/255, alpha: 1.0)
            
        } else if (row == 2) {
            themePicker.backgroundColor = UIColor(red: 0/255, green: 162/255, blue: 245/255, alpha: 1.0)
            
        } else if (row == 3) {
            themePicker.backgroundColor = UIColor(red: 46/255, green: 177/255, blue: 135/255, alpha: 1.0)
            
        } else if (row == 4) {
            themePicker.backgroundColor = UIColor(red: 186/255, green: 178/255, blue: 181/255, alpha: 1.0)
            
        } else if (row == 5) {
            themePicker.backgroundColor = UIColor(red: 208/255, green: 88/255, blue: 188/255, alpha: 1.0)
            
        } else if (row == 6) {
            themePicker.backgroundColor = UIColor(red: 239/255, green: 152/255, blue: 0/255, alpha: 1.0)
            
        } else if (row == 7) {
            themePicker.backgroundColor = UIColor(red: 223/255, green: 204/255, blue: 31/255, alpha: 1.0)
            
        }
    }
}

