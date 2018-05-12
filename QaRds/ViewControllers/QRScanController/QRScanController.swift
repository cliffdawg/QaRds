//
//  ViewController.swift
//  QaRds
//
//  Created by Clifford Yin on 2/4/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
//import CoreData

/* Manager of the QR code scanner */
class QRScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var QRlabel: UILabel!
    
    // This objectID represents the key of the data grouped in Firebase
    var objectID: String = ""
    
    @IBOutlet weak var whiteBar: UIView!
    @IBOutlet weak var QRnavigate: UINavigationBar!
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoCapture()
        addVideoPreviewLayer()
        initializeQRView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: QR Scanner implementation
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        self.view.bringSubview(toFront: QRnavigate)
        self.view.bringSubview(toFront: whiteBar)
        self.view.bringSubview(toFront: QRlabel)

    }
    
    // If a valid QR code is fixated, a green layer will materialize over it
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5).cgColor
        vwQRCode?.layer.borderColor = UIColor.green.cgColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubview(toFront: vwQRCode!)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            return
        }
        
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                
                QRlabel.text = objMetadataMachineReadableCodeObject.stringValue
                objectID = objMetadataMachineReadableCodeObject.stringValue
               
                
            }
        }
    }
    
    // After "save" button is pressed upon valid QR
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Save" {
            let contactsViewController = segue.destination as! ContactsViewController
            
            // uses the method in ContactsViewController to get the card with this ID
            contactsViewController.getDataFromId(objectId: objectID)
            
        }
    }
}

