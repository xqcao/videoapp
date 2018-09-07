//
//  ViewController.swift
//  videoDemo2
//
//  Created by xiaoqiang cao on 7/1/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
   
    

   
    @IBOutlet weak var videoStartBTN: UIButton!
    
    @IBOutlet weak var videoStopBTN: UIButton!
    @IBOutlet weak var takePicture: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    var device: AVCaptureDevice?
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    
    var currectCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var movieOutput = AVCaptureMovieFileOutput()
    
    var videoCaptureDevice : AVCaptureDevice?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //device = AVCaptureDevice.default(for: AVMediaType.video)
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
    }
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySission = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySission.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        
        
        currectCamera = backCamera
    }
    func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currectCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }

    }
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }

    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toStartRecord(_ sender: Any) {
        
        
        
        print("start recording ....")
    }
    
    @IBAction func toStopRecord(_ sender: Any) {
        print("record stoped!")
        captureSession.stopRunning()
    }
    
    @IBAction func toTakePicture(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto_Segue"{
//            let previewVC = segue.destination
//            previewVC.image = self.image
            
        }
    }
    
}

extension ViewController: AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageDate =  photo.fileDataRepresentation(){
            print(imageDate)
            image = UIImage(data: imageDate)
            performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
        }
    }
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // This code just exists for getting the before size. You can remove it from production code
        do {
            let data = try Data(contentsOf: outputFileURL)
            print("File size before compression: \(Double(data.count / 1048576)) mb")
        } catch {
            print("Error: \(error)")
        }
        // This line creates a generic filename based on UUID, but you may want to use your own
        // The extension must match with the AVFileType enum
        let path = NSTemporaryDirectory() + UUID().uuidString + ".m4v"
        let outputURL = URL.init(fileURLWithPath: path)
        let urlAsset = AVURLAsset(url: outputURL)
        // You can change the presetName value to obtain different results
        if let exportSession = AVAssetExportSession(asset: urlAsset,
                                                    presetName: AVAssetExportPresetMediumQuality) {
            exportSession.outputURL = outputURL
            // Changing the AVFileType enum gives you different options with
            // varying size and quality. Just ensure that the file extension
            // aligns with your choice
            exportSession.outputFileType = AVFileType.mov
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .unknown: break
                case .waiting: break
                case .exporting: break
                case .completed:
                    // This code only exists to provide the file size after compression. Should remove this from production code
                    do {
                        let data = try Data(contentsOf: outputFileURL)
                        print("File size after compression: \(Double(data.count / 1048576)) mb")
                    } catch {
                        print("Error: \(error)")
                    }
                case .failed: break
                case .cancelled: break
                }
            }
        }
    }
    
    
}
