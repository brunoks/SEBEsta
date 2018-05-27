//
//  ViewController.swift
//  QRCode_ideal
//
//  Created by Bruno Vieira on 26/05/18.
//  Copyright © 2018 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    var qrCodeFrameView:UIView?
    var link: String?
    
    @IBOutlet weak var btnShareLink: UIButton!
    @IBOutlet weak var btnexecuteLink: UIButton!
    @IBOutlet weak var UIViewPopUp: UIView!
    @IBOutlet weak var btnNewQRCode: UIButton!
    @IBOutlet weak var UITable: UITableView!
    @IBOutlet weak var labelLink: UILabel!
    @IBOutlet weak var UIViewQRCode: UIView!
    @IBOutlet weak var TFQRCode: UITextField!
    @IBOutlet weak var btnGenerate: UIButton!
    @IBOutlet weak var UIViewScan: UIView!
    @IBOutlet weak var QRImgView: UIImageView!
    
    
    @IBOutlet weak var switchSegment: UISegmentedControl!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var btnScan: UIButton!
    
    //func para criar o QRCode
    @IBAction func btnGenerateQRCode(_ sender: Any) {
        
        UIViewQRCode.isHidden = false;
        UIViewQRCode.layer.cornerRadius = 2
        UIViewQRCode.layer.borderWidth = 0.5
        UIViewQRCode.layer.borderColor = UIColor.blue.cgColor
        
        if(TFQRCode.hasText){
            
            if let link = TFQRCode.text {
                let data = link.data(using: .ascii, allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "inputMessage")
                
                let img = UIImage(ciImage: (filter?.outputImage)!)
                QRImgView.image = img
                
                
            }
        }
    }
    //func para capturar scan
    @IBAction func btnView(_ sender: Any) {
        if(uiView.isHidden == true){
            uiView.isHidden = false;
            uiView.layer.cornerRadius = 5;
            buttonDesign();
        }else{
            uiView.isHidden = true;
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: UIViewScan)
        session.startRunning()
        switchSegment.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0
            {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                link = object.stringValue
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                    UIPasteboard.general.string = object.stringValue
                }))
                present(alert, animated:true, completion: nil)
            }
        }
    }
    
    func buttonDesign(){
        //Estiliza os botões do UIView
        btnShareLink.layer.cornerRadius = 3
        btnexecuteLink.layer.cornerRadius = 3
        btnNewQRCode.layer.cornerRadius = 3
    }
    @IBAction func switchSegmentAct(_ sender: Any) {
        
        switch switchSegment.selectedSegmentIndex {
            
        case 0:
            hiddenAll()
            btnScan.isHidden = false;
            UIViewScan.isHidden = false;
        case 1:
            hiddenAll()
            UITable.isHidden = false;
            
        case 2:
            hiddenAll()
            btnGenerate.isHidden = false;
            TFQRCode.isHidden = false;
            btnGenerate.layer.cornerRadius = 2;
            TFQRCode.layer.cornerRadius = 2
            
            
        case 3:
            let textToShare = "SAC DIGITAL"
            
            if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
                let objectsToShare = [textToShare, myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = sender as! UIView
                self.present(activityVC, animated: true, completion: nil)
            }
        case 4:
            UIViewPopUp.isHidden = false;
            UIViewPopUp.center.y = view.bounds.width
            
        default: break
            
        }
        
    }
    
    func styleButton(button: UIButton){
        
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        btnScan.layer.borderColor = UIColor.green.cgColor
    }
    
    func hiddenAll(){
        btnScan.isHidden = true;
        UIViewScan.isHidden = true;
        UITable.isHidden = true;
        btnGenerate.isHidden = true;
        TFQRCode.isHidden = true;
        TFQRCode.clearsOnInsertion = true
        uiView.isHidden = true;
        UIViewPopUp.isHidden = true;
        btnNewQRCode.isHidden = true;
        UIViewQRCode.isHidden = true;
    }
}



