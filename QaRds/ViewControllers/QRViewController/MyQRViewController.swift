//
//  MyQRViewController.swift
//  QaRds
//
//  Created by Clifford Yin on 2/5/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

/* Code for this page to display a corresponsing QR code for a user's card. */
class MyQRViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var card: Card?
    var named: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

        updateWebView()
    }
    
    // Updates the web view with the dynamic QR code generator website to display the corresponsing card's
    func updateWebView() {
        named = card!.objectId!
        let named2 = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=" + named
        print(named2)
        UIWebView.loadRequest(webView)(URLRequest(url: NSURL(string: named2)! as URL))
        
        let cardTheme = card?.theme
        
        // Sets the background color to the same as the card
        if (cardTheme == 1) {
            self.view.backgroundColor = UIColor(red: 208/255, green: 29/255, blue: 0/255, alpha: 1.0)
            
        } else if (cardTheme == 2) {
            self.view.backgroundColor = UIColor(red: 0/255, green: 162/255, blue: 245/255, alpha: 1.0)
            
        } else if (cardTheme == 3) {
            self.view.backgroundColor = UIColor(red: 46/255, green: 177/255, blue: 135/255, alpha: 1.0)
            
        } else if (cardTheme == 4) {
            self.view.backgroundColor = UIColor(red: 186/255, green: 178/255, blue: 181/255, alpha: 1.0)
            
        } else if (cardTheme == 5) {
            self.view.backgroundColor = UIColor(red: 208/255, green: 88/255, blue: 188/255, alpha: 1.0)
            
        } else if (cardTheme == 6) {
            self.view.backgroundColor = UIColor(red: 239/255, green: 152/255, blue: 0/255, alpha: 1.0)
            
        } else if (cardTheme == 7) {
            self.view.backgroundColor = UIColor(red: 223/255, green: 204/255, blue: 31/255, alpha: 1.0)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
