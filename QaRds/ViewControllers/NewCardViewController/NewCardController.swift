//
//  NewCardController.swift
//  QaRds
//
//  Created by Clifford Yin on 2/4/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import JVFloatLabeledTextField
import Parse
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AlamofireImage
import Alamofire

/* Code that manages the screen where the user generated his or her own new business card. */
class NewCardController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, ChooseThemeDelegate, UITextFieldDelegate{
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: JVFloatLabeledTextField!
    @IBOutlet weak var positionField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneField: JVFloatLabeledTextField!
    @IBOutlet weak var emailField: JVFloatLabeledTextField!
    @IBOutlet weak var websiteField: JVFloatLabeledTextField!
    @IBOutlet weak var organizationField: JVFloatLabeledTextField!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: Properties
    
    var imagePickerController: UIImagePickerController?
    var image: UIImage = UIImage(named: "profile_default")!
    let storageRef = Storage.storage().reference()
    let ref = Database.database().reference()
    
    // Default theme color is blue
    var themed = 2
    
    override func viewDidLoad() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        // Implements delegates that limit character count in textFields
        nameField.delegate = self as UITextFieldDelegate
        organizationField.delegate = self as UITextFieldDelegate
        positionField.delegate = self as UITextFieldDelegate
        emailField.delegate = self as UITextFieldDelegate
        phoneField.delegate = self as UITextFieldDelegate
        websiteField.delegate = self as UITextFieldDelegate
        nameField.tag = 1
        organizationField.tag = 2
        positionField.tag = 3
        emailField.tag = 4
        phoneField.tag = 5
        websiteField.tag = 6
        
        self.selectButton.layer.cornerRadius = 5
        let defaultPic: UIImage = UIImage(named: "profile_default")!
        imageView.layer.cornerRadius = imageView.frame.width / 2;
        imageView.clipsToBounds = true
        imageView.image = defaultPic
        
        // allows photo to be tapped
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewCardController.imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        self.view.backgroundColor = UIColor.white
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewCardController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // For a theme chosen, its specific color is implemented
    func chooseTheme(chosenTheme: Int) {
        
        themed = chosenTheme
       
        if (themed == 0){
            self.themed = 2
            self.selectButton.setTitle("Select", for: .normal)
            self.selectButton.setTitleColor(UIColor(red: 0/255, green: 162/255, blue: 245/255, alpha: 1.0), for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 1) {
            self.selectButton.setTitle("Red", for: .normal)
            self.selectButton.setTitleColor(.red, for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 2) {
            self.selectButton.setTitle("Blue", for: .normal)
            self.selectButton.setTitleColor(.blue, for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 3) {
            self.selectButton.setTitle("Green", for: .normal)
            self.selectButton.setTitleColor(.green, for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 4) {
            self.selectButton.setTitle("Gray", for: .normal)
            self.selectButton.setTitleColor(.gray, for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 5) {
            self.selectButton.setTitle("Purple", for: .normal)
            self.selectButton.setTitleColor(.purple, for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 6) {
            self.selectButton.setTitle("Orange", for: .normal)
            self.selectButton.setTitleColor(.orange, for: .normal)
            self.selectButton.backgroundColor = .clear
        } else if (themed == 7) {
            self.selectButton.setTitle("Yellow", for: .normal)
            self.selectButton.setTitleColor(.yellow, for: .normal)
            self.selectButton.backgroundColor = .gray
        } 
    }
    
    
    // When the "theme" button is pressed, it presents the theme-picker as a pop-up
    @IBAction func selectingTheme(_ sender: Any) {
        let popoverViewController = self.storyboard?.instantiateViewController(withIdentifier: "themeChoices") as! themeChoices
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width:300, height:150)
        popoverViewController.delegate2 = self
        let popoverPresentationViewController = popoverViewController.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.down
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.sourceView = self.selectButton
        popoverPresentationViewController?.sourceRect = CGRect(x:0, y:0, width: selectButton.frame.width, height: 30)
        
        present(popoverViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Store the entered information and chosen picture in Firebase database and storage
    func uploadCard() {
        
        var name = nameField.text ?? "N/A"
        var email = emailField.text ?? "N/A"
        var phone = phoneField.text ?? "N/A"
        var position = positionField.text ?? "N/A"
        let theme = self.themed
        var website = websiteField.text ?? "N/A"
        var organization = organizationField.text ?? "N/A"
        let createdByPhone = UIDevice.current.identifierForVendor!.uuidString
        
        // If empty fields, set to default "N/A" value
        if (name.trimmingCharacters(in: .whitespaces).isEmpty) == true {
            name = "N/A"
        }
        if (email.trimmingCharacters(in: .whitespaces).isEmpty) == true {
            email = "N/A"
        }
        if (phone.trimmingCharacters(in: .whitespaces).isEmpty) == true {
            phone = "N/A"
        }
        if (position.trimmingCharacters(in: .whitespaces).isEmpty) == true {
            position = "N/A"
        }
        if (website.trimmingCharacters(in: .whitespaces).isEmpty) == true {
            website = "N/A"
        }
        if (organization.trimmingCharacters(in: .whitespaces).isEmpty) == true {
            organization = "N/A"
        }
        
        let refd = ref.childByAutoId()
        
        refd.setValue(["name": name, "organization": organization, "position": position, "email": email, "phone": phone, "website": website, "createdByPhone": createdByPhone, "theme": theme])
        
        let refdStore = refd.key
        let mountainsRef = storageRef.child(refdStore)
        let localFile = UIImagePNGRepresentation(image)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        mountainsRef.putData(localFile!, metadata: nil)
    }
    
    
    @IBAction func savePressed(sender: AnyObject) {
        uploadCard()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: Image Methods
    
    func imageTapped(_ gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            // Allows user to choose between photo library and camera
            let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .default) { (action) in
                self.showImagePickerController(sourceType: .photoLibrary)
            }
            
            alertController.addAction(photoLibraryAction)
            
            // Only show camera option if rear camera is available
            if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                let cameraAction = UIAlertAction(title: "Photo from Camera", style: .default) { (action) in
                    self.showImagePickerController(sourceType: .camera)
                }
                alertController.addAction(cameraAction)
            }
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .center
            // Scale it so it occupies less data in Firebase storage
            let size2 = CGSize(width: 150.0, height: 150.0)
            image = pickedImage.af_imageScaled(to: size2)
            let size = CGSize(width: 125.0, height: 125.0)
            imageView.image = pickedImage.af_imageScaled(to: size)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        present(imagePickerController!, animated: true, completion: nil)
    }
    
    // MARK: textFieldDelegate Overrides
    
    // Limit the character count for each field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        if (textField.tag == 1) {
        return newLength <= 31
        } else if (textField.tag == 2) {
            return newLength <= 32
        } else if (textField.tag == 3) {
            return newLength <= 40
        } else if (textField.tag == 4) {
            return newLength <= 42
        } else if (textField.tag == 5) {
            return newLength <= 22
        } else if (textField.tag == 6) {
            return newLength <= 41
        } else {
            return true
        }
    }
}
