//
//  ContactCell.swift
//  QaRds
//
//  Created by Clifford Yin on 2/4/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorageUI
import FirebaseDatabase
import Firebase
import FirebaseStorage
import Alamofire
import AlamofireImage

/* Cell for user contacts' business cards*/
class ContactCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var website: UILabel!
    
    var storageRef: StorageReference!
    
    // Pull images from Storage
    func configure(ided: String) {
        self.storageRef = Storage.storage().reference()
        let reference = storageRef.child(ided)
        self.picture.sd_setImage(with: reference)
        self.picture.contentMode = .center
        // optimal for vertical pics
        let size = CGSize(width: 100.0, height: 130.0)
        self.picture.image = (picture.image?.af_imageScaled(to: size))
        // make circle
        self.picture.layer.cornerRadius = self.picture.frame.width / 2;
    }
    
}
