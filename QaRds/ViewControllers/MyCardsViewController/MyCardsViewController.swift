//
//  File.swift
//  QaRds
//
//  Created by Clifford Yin on 2/4/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI

/* Code that constitutes the user personal business card page. Upon loading, the program searches for the data structures with corresponding "createdByPhone" strings in the Firebase data that matches this device's, and instantiates them as "Cards" locally. */
class MyCardsViewController: UITableViewController {
    
    var cardTemp = [Card](){
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: ViewController Overrides
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        // Checks for internet connection
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        self.load()
    }
    
    // If a Card is selected, the program pulls up a QR code associated with it. This is for other phones/apps to scan and add as a Contact card.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openQR") {
            let QRViewController = segue.destination as! MyQRViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let obj = cardTemp[indexPath!.row]
            QRViewController.card = obj
        }
    }
    
    
    // Loads all the user's cards from Firebase database
    func load(){
        
        let ref = Database.database().reference()
        var newCards = [Card]()
        
        ref.observe(.value) { (snapshot: DataSnapshot!) in
            newCards.removeAll()
            for item in snapshot.children {
                // Searches for all Cards generated by this user and adds their information fields as a new Card
                let card = Card()
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let cardValue = childSnapshot.value as? NSDictionary
                let id = cardValue?["createdByPhone"] as! String
                
                if (id == UIDevice.current.identifierForVendor!.uuidString){
                    let cardValue = childSnapshot.value as? NSDictionary
                    let named = cardValue?["name"] as! String
                    let orged = cardValue?["organization"] as! String
                    let positioned = cardValue?["position"] as! String
                    let emailed = cardValue?["email"] as! String
                    let phoned = cardValue?["phone"] as! String
                    let websited = cardValue?["website"] as! String
                    let createdByPhoned = cardValue?["createdByPhone"] as! String
                    let themed = cardValue?["theme"] as! Int
                    let key = childSnapshot.key
                    card.name = named
                    card.organization = orged
                    card.position = positioned
                    card.email = emailed
                    card.phone = phoned
                    card.website = websited
                    card.createdByPhone = createdByPhoned
                    card.theme = themed
                    card.objectId = key
                    
                    newCards.append(card)
                    self.cardTemp = newCards
                }
            }
        }
    }
    
    
    // MARK: TableViewController Overrides
    
    // Displays all the cells as user contact cards
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCardCell", for: indexPath as IndexPath) as! MyCardCell
        let card = cardTemp[indexPath.row]
        cell.picture.clipsToBounds = true
        cell.configure(ided: (card.objectId)!)
        cell.cardView.layer.cornerRadius = 15
        cell.cardView.layer.masksToBounds = true
        cell.name.text = card.name
        cell.position.text = card.position!
        cell.phoneNum.text = card.phone
        cell.email.text = card.email
        cell.organization.text = card.organization
        cell.website.text = card.website
    
        if (card.theme == 1) {
            cell.cardView.backgroundColor = UIColor(red: 208/255, green: 29/255, blue: 0/255, alpha: 1.0)
            
        } else if (card.theme == 2) {
            cell.cardView.backgroundColor = UIColor(red: 0/255, green: 162/255, blue: 245/255, alpha: 1.0)
            
        } else if (card.theme == 3) {
            cell.cardView.backgroundColor = UIColor(red: 46/255, green: 177/255, blue: 135/255, alpha: 1.0)
            
        } else if (card.theme == 4) {
            cell.cardView.backgroundColor = UIColor(red: 186/255, green: 178/255, blue: 181/255, alpha: 1.0)
            
        } else if (card.theme == 5) {
            cell.cardView.backgroundColor = UIColor(red: 208/255, green: 88/255, blue: 188/255, alpha: 1.0)
            
        } else if (card.theme == 6) {
            cell.cardView.backgroundColor = UIColor(red: 239/255, green: 152/255, blue: 0/255, alpha: 1.0)
            
        } else if (card.theme == 7) {
            cell.cardView.backgroundColor = UIColor(red: 223/255, green: 204/255, blue: 31/255, alpha: 1.0)
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardTemp.count
    }
    
    
    override func tableView(_ tableView: UITableView?, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath?) {
        
        if editingStyle == .delete {
            
            let ref = Database.database().reference()
            let search = self.cardTemp[(indexPath?.row)!].objectId!
            
            ref.observe(.value) { (snapshot: DataSnapshot!) in
                for item in snapshot.children {
                    
                    let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                    let ided = childSnapshot.key
                    
                    // If the deleted key is the same in Firebase as locally, remove it
                    if search == ided {
                        (item as AnyObject).ref.removeValue()
                        
                    }
                }
            }
            
            let alertController = UIAlertController(title: "Card deleted!", message:nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            tableView!.reloadData()
        }
    }

    
    @IBAction func unwindToMyCardsViewController(segue: UIStoryboardSegue) {
    }
}
