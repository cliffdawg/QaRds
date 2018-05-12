//
//  TableViewController.swift
//  QaRds
//
//  Created by Clifford Yin on 2/4/16.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import Foundation
import ChameleonFramework
import CoreData
import Parse
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseStorageUI

/* Code for managing the Contacts page. Card ID's are stored in Core Data; upon loading, the program searches for the data structures with corresponding ID's in the Firebase data and instantiates them as "Cards" locally. */
class ContactsViewController: UITableViewController {
    
    var cards = [NSManagedObject]()

    var cardTemp = [Card]()
    
    // MARK: ViewController Overrides
    
    override func viewDidLoad() {
        // Checks for internet connection
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.load()
    }
    
    // Saved the scanned objectID
    func getDataFromId(objectId: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
                                let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "Card", in:managedContext)
        
        let adding = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        adding.setValue(objectId, forKey: "objectid")
        
        do {
                try managedContext.save()
                self.cards.append(adding)
                                        
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                }
        }
    
    
    // Loads all the user's contacts from Firebase database
    func load(){
        
        let storageRef = Storage.storage().reference()
        let ref = Database.database().reference()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext =
            appDelegate.managedObjectContext
        
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            cards = data as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var newCards = [Card]()
        
        ref.observe(.value) { (snapshot: DataSnapshot!) in
            
            for cardd in self.cards {
                for item in snapshot.children {
                    // Upon locating the right key, all those associated data values will be assigned to a new Card
                    let card = Card()
                    let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                    let cardValue = childSnapshot.value as? NSDictionary
                    let key = childSnapshot.key
                    
                    if (key == cardd.value(forKey: "objectid") as! String) {
                        let cardValue = childSnapshot.value as? NSDictionary
                        let named = cardValue?["name"] as! String
                        let orged = cardValue?["organization"] as! String
                        let positioned = cardValue?["position"] as! String
                        let emailed = cardValue?["email"] as! String
                        let phoned = cardValue?["phone"] as! String
                        let websited = cardValue?["website"] as! String
                        let createdByPhoned = cardValue?["createdByPhone"] as! String
                        let themed = cardValue?["theme"] as! Int
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
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: TableViewController Overrides
    
    // This deletes the stored Contact card ID
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        if editingStyle == .delete {
            
            context.delete(cards[indexPath.row] )
            cards.remove(at: indexPath.row)
            cardTemp.remove(at: indexPath.row)
            
            do {
                try context.save()}
            catch {
            }
            
            load()
            tableView.reloadData()
            
            let alertController = UIAlertController(title: "Card deleted!", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    

    // Displays all the cells as user contact cards
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath as IndexPath) as! ContactCell
        let card = cardTemp[indexPath.row]
        cell.picture.clipsToBounds = true
        cell.configure(ided: (card.objectId)!)
        cell.cardView.layer.cornerRadius = 15
        cell.cardView.layer.masksToBounds = true
        cell.nameLabel.text = card.name
        cell.position.text = card.position!
        cell.phone.text = card.phone
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
    
    @IBAction func unwindToContactsViewController(segue: UIStoryboardSegue) {}
}

