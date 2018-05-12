////
////  ThemePicker.swift
////  QaRds
////
////  Created by Clifford Yin on 7/6/17.
////  Copyright © 2017 Clifford Yin. All rights reserved.
////
//
//import UIKit
//import Foundation
//import ChameleonFramework
//
//class ThemePicker: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
//    @IBOutlet weak var tableView: UITableView!
//    var selectedTheme: String?
//    var themeIndex: Int?
//    
//    let flatColors: [(String, UIColor)] = [
//        ("Black", UIColor.flatBlackColor()),
//        ("Blue", UIColor.flatBlueColor()),
//        ("Brown", UIColor.flatBrownColor()),
//        ("Green", UIColor.flatForestGreenColor()),
//        ("Gray", UIColor.flatGrayColor()),
//        ("Green", UIColor.flatGreenColor()),
//        ("Lime", UIColor.flatLimeColor()),
//        ("Magenta", UIColor.flatMagentaColor()),
//        ("Maroon", UIColor.flatMaroonColor()),
//        ("Mint", UIColor.flatMintColor()),
//        ("Orange", UIColor.flatOrangeColor()),
//        ("Pink", UIColor.flatPinkColor()),
//        ("PowderBlue", UIColor.flatPowderBlueColor()),
//        ("Purple", UIColor.flatPurpleColor()),
//        ("Red", UIColor.flatRedColor()),
//        ("Teal", UIColor.flatTealColor()),
//        ("Watermelon", UIColor.flatWatermelonColor()),
//        ("Sky Blue", UIColor.flatSkyBlueColor()),
//        ("Yellow", UIColor.flatYellowColor())
//    ]
//    
//    let gradientColors: [(String, [UIColor])] = [
//        ("Red/Purple", [UIColor.flatRedColor(), UIColor.flatPurpleColor()]),
//        ("Blue/Green", [UIColor.flatMintColor(), UIColor.flatSkyBlueColor()]),
//        ("Yellow/Orange", [UIColor.flatYellowColor(), UIColor.flatOrangeColor()]),
//        ("Lime/Green", [UIColor.flatLimeColor(), UIColor.flatGreenColor()]),
//        ("Mint/Blue", [UIColor.flatMintColor(), UIColor.flatBlueColorDark()]),
//        ("Gray/Black", [UIColor.flatGrayColor(), UIColor.flatBlackColor()])
//    ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func reloadTableView(sender: AnyObject) {
//        tableView.reloadData()
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var rowNum = 0
//        
//        switch(mySegmentedControl.selectedSegmentIndex) {
//        //flat colors
//        case 0:
//            rowNum = flatColors.count
//            break
//        //gradient colors
//        case 1:
//            rowNum = gradientColors.count
//            break
//            
//        default:
//            break
//        }
//        return rowNum
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! ThemePickerCell
//        
//        switch(mySegmentedControl.selectedSegmentIndex) {
//        case 0:
//            cell.colorLabel.text = flatColors[indexPath.row].0
//            cell.colorPreview.backgroundColor = flatColors[indexPath.row].1
//            break
//        case 1:
//            cell.colorLabel.text = gradientColors[indexPath.row].0
//            cell.colorPreview.backgroundColor = GradientColor(UIGradientStyle.TopToBottom, frame: view.frame, colors: gradientColors[indexPath.row].1)
//            break
//        default:
//            break
//        }
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let indexPath = tableView.indexPathForSelectedRow!
//        //let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! ThemePickerCell
//        themeIndex = indexPath.row
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//            if(identifier == "pickerDone") {
//                selectedTheme = flatColors[themeIndex!].1.toHexString()
//                let newCardController = segue.destinationViewController as! NewCardController
//                newCardController.view.backgroundColor = UIColor(hexString: selectedTheme)
//                newCardController.hexTheme = selectedTheme
//            }
//        }
//    }
//}
//
//extension UIColor {
//    convenience init(hexString:String) {
//        let hexString: NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        let scanner = NSScanner(string: hexString as String)
//        
//        if (hexString.hasPrefix("#")) {
//            scanner.scanLocation = 1
//        }
//        
//        var color:UInt32 = 0
//        scanner.scanHexInt(&color)
//        
//        let mask = 0x000000FF
//        let r = Int(color >> 16) & mask
//        let g = Int(color >> 8) & mask
//        let b = Int(color) & mask
//        
//        let red   = CGFloat(r) / 255.0
//        let green = CGFloat(g) / 255.0
//        let blue  = CGFloat(b) / 255.0
//        
//        self.init(red:red, green:green, blue:blue, alpha:1)
//    }
//    
//    func toHexString() -> String {
//        var r:CGFloat = 0
//        var g:CGFloat = 0
//        var b:CGFloat = 0
//        var a:CGFloat = 0
//        
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        
//        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//        
//        return NSString(format:"#%06x", rgb) as String
//    }
//}
