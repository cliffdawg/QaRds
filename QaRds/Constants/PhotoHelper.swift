//
//  PhotoHelper.swift
//  QaRds
//
//  Created by Clifford Yin on 2/4/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import Foundation
import UIKit

typealias PhotoTakingHelperCallback = (UIImage?) -> Void

/* Code that assists with image-choosing functionality */
class PhotoHelper {
    
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: @escaping PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        showPhotoSourceSelection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPhotoSourceSelection() {
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
        viewController.present(alertController, animated: true, completion: nil)
    }

    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        viewController.present(imagePickerController!, animated: true, completion: nil)
    }
}
