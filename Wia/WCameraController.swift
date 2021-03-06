//
//  WCameraController.swift
//  Wia
//
//  Created by Abbin Varghese on 31/12/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol WCameraControllerDelegate {
    func cameraController(remove: [PHAsset])
}

class WCameraController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, WImagePickerControllerDelegate {
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var viewFinder: WViewFinder!
    @IBOutlet weak var cameraUnavailableMessage: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Constants
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil)
    private let photoOutput = AVCapturePhotoOutput()
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var delegate: WCameraControllerDelegate?
    var imageCount: Int!
    var imageManager: PHCachingImageManager!
    private var sessionRunningObserveContext = 0
    private var isSessionRunning = false
    private var inProgressPhotoCaptureDelegates = [Int64 : PhotoCaptureDelegate]()
    private var flashMode = AVCaptureFlashMode.auto
    private var setupResult: SessionSetupResult = .success
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var takenImageAssets = [PHAsset]()
    private var thumbnailSize: CGSize!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale = UIScreen.main.scale
        let cellSize = (imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        doneButton.isHidden = true
        shutterButton.isEnabled = false
        viewFinder.session = session
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            break
            
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                    DispatchQueue.main.async {
                        self.cameraUnavailableMessage.isHidden = false
                    }
                }
                self.sessionQueue.resume()
            })
            
        default:
            setupResult = .notAuthorized
        }
        
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
        
        imageCollectionView.register(UINib.init(nibName: "WCameraImagePreviewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "WCameraImagePreviewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.addObservers()
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                
            case .notAuthorized:
                self.cameraUnavailableMessage.isHidden = false
                
            case .configurationFailed:
                self.cameraUnavailableMessage.isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async { [unowned self] in
            if self.setupResult == .success {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
                self.removeObservers()
            }
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func goToSettings(_ sender: Any) {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func changeFlash(_ sender: Any) {
        if flashMode == .auto {
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOff"), for: .normal)
        }
        else{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashOn"), for: .normal)
        }
    }
    
    @IBAction func dismisCamera(_ sender: Any) {
        delegate?.cameraController(remove: takenImageAssets)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneWithCamera(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func capturePhoto(_ photoButton: UIButton) {
        
        let videoPreviewLayerOrientation = viewFinder.videoPreviewLayer.connection.videoOrientation
        
        sessionQueue.async {
            if let photoOutputConnection = self.photoOutput.connection(withMediaType: AVMediaTypeVideo) {
                photoOutputConnection.videoOrientation = videoPreviewLayerOrientation
            }
            
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.flashMode = self.flashMode
            photoSettings.isHighResolutionPhotoEnabled = true
            if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
            }
            
            let photoCaptureDelegate = PhotoCaptureDelegate(with: photoSettings, willCapturePhotoAnimation: {
                DispatchQueue.main.async { [unowned self] in
                    self.viewFinder.videoPreviewLayer.opacity = 0
                    UIView.animate(withDuration: 0.25) { [unowned self] in
                        self.viewFinder.videoPreviewLayer.opacity = 1
                    }
                }
            }, completed: { [unowned self] photoCaptureDelegate in
                self.sessionQueue.async { [unowned self] in
                    self.inProgressPhotoCaptureDelegates[photoCaptureDelegate.requestedPhotoSettings.uniqueID] = nil
                }
                }
            )
            
            self.inProgressPhotoCaptureDelegates[photoCaptureDelegate.requestedPhotoSettings.uniqueID] = photoCaptureDelegate
            self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureDelegate)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return takenImageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = takenImageAssets[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WCameraImagePreviewCell", for: indexPath) as! WCameraImagePreviewCell
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: width)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WImagePickerControllerDelegate
    
    func imagePickerController(controller: WImagePickerController, photoLibraryDidChangeWith asset: PHAsset) {
        takenImageAssets.append(asset)
        imageCollectionView.reloadData()
        imageCollectionView.scrollToItem(at: IndexPath.init(row: takenImageAssets.count - 1, section: 0), at: .bottom, animated: true)
        if takenImageAssets.count == imageCount {
            dismiss(animated: true, completion: nil)
        }
        if takenImageAssets.count > 0 {
            doneButton.isHidden = false
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Notifications
    
    func subjectAreaDidChange(notification: NSNotification) {
        let devicePoint = CGPoint(x: 0.5, y: 0.5)
        focus(with: .autoFocus, exposureMode: .continuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &sessionRunningObserveContext {
            let newValue = change?[.newKey] as AnyObject?
            guard let isSessionRunning = newValue?.boolValue else { return }
            
            DispatchQueue.main.async { [unowned self] in
                self.shutterButton.isEnabled = isSessionRunning
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func sessionInterruptionEnded(notification: NSNotification) {
        print("Capture session interruption ended")
        
        if !cameraUnavailableMessage.isHidden {
            UIView.animate(withDuration: 0.25,
                           animations: { [unowned self] in
                            self.cameraUnavailableMessage.alpha = 0
                }, completion: { [unowned self] finished in
                    self.cameraUnavailableMessage.isHidden = true
                }
            )
        }
    }
    
    func sessionRuntimeError(notification: NSNotification) {
        guard let errorValue = notification.userInfo?[AVCaptureSessionErrorKey] as? NSError else {
            return
        }
        
        let error = AVError(_nsError: errorValue)
        print("Capture session runtime error: \(error)")
        
        if error.code == .mediaServicesWereReset {
            sessionQueue.async { [unowned self] in
                if self.isSessionRunning {
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                }
            }
        }
    }
    
    func sessionWasInterrupted(notification: NSNotification) {
        if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?, let reasonIntegerValue = userInfoValue.integerValue, let reason = AVCaptureSessionInterruptionReason(rawValue: reasonIntegerValue) {
            print("Capture session was interrupted with reason \(reason)")
            
            if reason == AVCaptureSessionInterruptionReason.videoDeviceNotAvailableWithMultipleForegroundApps {
                cameraUnavailableMessage.alpha = 0
                cameraUnavailableMessage.isHidden = false
                UIView.animate(withDuration: 0.25) { [unowned self] in
                    self.cameraUnavailableMessage.alpha = 1
                }
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Private Functions
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
        session.removeObserver(self, forKeyPath: "running", context: &sessionRunningObserveContext)
    }
    
    private func configureSession() {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            if let dualCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera, mediaType: AVMediaTypeVideo, position: .back) {
                defaultVideoDevice = dualCameraDevice
            }
            else if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
                defaultVideoDevice = backCameraDevice
            }
            else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                DispatchQueue.main.async {
                    let statusBarOrientation = UIApplication.shared.statusBarOrientation
                    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                    if statusBarOrientation != .unknown {
                        if let videoOrientation = statusBarOrientation.videoOrientation {
                            initialVideoOrientation = videoOrientation
                        }
                    }
                    
                    self.viewFinder.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation
                }
            }
            else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        }
        catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        if session.canAddOutput(photoOutput)
        {
            session.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = false
        }
        else {
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
    }
    
    private func addObservers() {
        session.addObserver(self, forKeyPath: "running", options: .new, context: &sessionRunningObserveContext)
        
        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange), name: Notification.Name("AVCaptureDeviceSubjectAreaDidChangeNotification"), object: videoDeviceInput.device)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionRuntimeError), name: Notification.Name("AVCaptureSessionRuntimeErrorNotification"), object: session)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted), name: Notification.Name("AVCaptureSessionWasInterruptedNotification"), object: session)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionEnded), name: Notification.Name("AVCaptureSessionInterruptionEndedNotification"), object: session)
    }
    
    private func focus(with focusMode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, at devicePoint: CGPoint, monitorSubjectAreaChange: Bool) {
        sessionQueue.async { [unowned self] in
            if let device = self.videoDeviceInput.device {
                do {
                    try device.lockForConfiguration()
                    
                    if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                        device.focusPointOfInterest = devicePoint
                        device.focusMode = focusMode
                    }
                    
                    if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                        device.exposurePointOfInterest = devicePoint
                        device.exposureMode = exposureMode
                    }
                    
                    device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                    device.unlockForConfiguration()
                }
                catch {
                    print("Could not lock device for configuration: \(error)")
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - PhotoCaptureDelegate

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    private let willCapturePhotoAnimation: () -> ()
    
    private let completed: (PhotoCaptureDelegate) -> ()
    
    private var photoData: Data? = nil
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings, willCapturePhotoAnimation: @escaping () -> (), completed: @escaping (PhotoCaptureDelegate) -> ()) {
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.completed = completed
    }
    
    private func didFinish() {
        completed(self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, willCapturePhotoForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings) {
        willCapturePhotoAnimation()
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        }
        else {
            print("Error capturing photo: \(error)")
            return
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            didFinish()
            return
        }
        
        guard let photoData = photoData else {
            print("No photo data resource")
            didFinish()
            return
        }
        
        PHPhotoLibrary.requestAuthorization { [unowned self] status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    
                    let options = PHAssetResourceCreationOptions()
                    options.originalFilename = "WIA\(NSUUID().uuidString).JPG"
                    
                    creationRequest.addResource(with: .photo, data: photoData, options: options)
                    
                }, completionHandler: { [unowned self] success, error in
                    if let error = error {
                        print("Error occurered while saving photo to photo library: \(error)")
                    }
                    
                    self.didFinish()
                    }
                )
            }
            else {
                self.didFinish()
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - WViewFinder

class WViewFinder: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UIInterfaceOrientation Extension

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return nil
        }
    }
}
