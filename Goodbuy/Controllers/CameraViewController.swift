//
//  CameraViewController.swift
//  Hotline
//
//  Created by James Mudgett on 11/9/19.
//  Copyright © 2019 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import NextLevel
import Lorikeet
import DynamicColor
import AVFoundation
import Photos
import PhotosUI
import NextLevel
import SnapKit

class CameraViewController: UIViewController {

    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate var previewView: UIView?
    fileprivate var gestureView: UIView?
    fileprivate var focusView: FocusIndicatorView?
    
    fileprivate var tipBubble = TipBubbleView()
    
    fileprivate lazy var itemsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    fileprivate var itemInputViews: [ItemCameraEditView] = []

    fileprivate let recordButton = CaptureButton()
    
    fileprivate let thumbnailsView = CameraThumbnailsView()
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "camera-back"), for: .normal)
        button.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "minimize-camera"), for: .normal)
        button.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .headline, weight: .semibold)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 6
        return button
    }()
    
    fileprivate lazy var doneButton: RoundInterfaceButton = {
        let button = RoundInterfaceButton(radius: -1)
        button.backgroundColor = .clear
        button.setTitle("Review", for: .normal)
        button.addTarget(self, action: #selector(tappedDone), for: .touchUpInside)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        button.tintColor = .white
        button.backgroundColor = ColorManager.shared.defaultColor
        return button
    }()
    
    fileprivate lazy var itemsBadge: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.roundedFont(ofSize: .caption1, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = ColorManager.shared.accentColor
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 4
        label.layer.cornerRadius = 8.5
        label.layer.masksToBounds = true
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Listing"
        label.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.4
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 6
        return label
    }()
    
    fileprivate var gradientView = GradientBackgroundView()
    
    fileprivate lazy var lightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "flashlight"), for: .normal)
        button.addTarget(self, action: #selector(tappedFlash), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    fileprivate lazy var libraryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "library"), for: .normal)
        button.addTarget(self, action: #selector(tappedLibrary), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "next-item"), for: .normal)
        button.setImage(UIImage(named: "next-item-disabled"), for: .disabled)
        button.addTarget(self, action: #selector(tappedNext), for: .touchUpInside)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()

    fileprivate var recordGestureRecognizer: UILongPressGestureRecognizer?
    fileprivate var photoTapGestureRecognizer: UITapGestureRecognizer?
    fileprivate var focusTapGestureRecognizer: UITapGestureRecognizer?
    fileprivate var flipDoubleTapGestureRecognizer: UITapGestureRecognizer?
    
    fileprivate var _panStartPoint: CGPoint = .zero
    fileprivate var _panStartZoom: CGFloat = 0.0
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        let screenBounds = UIScreen.main.bounds

        previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.shared.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
            self.view.addSubview(previewView)
        }
        
        view.addSubview(gradientView)
        
        focusView = FocusIndicatorView(frame: .zero)
        
        recordButton.isUserInteractionEnabled = true
        
        recordGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(_:)))
        recordGestureRecognizer?.delegate = self
        recordGestureRecognizer?.minimumPressDuration = 0.25
        recordGestureRecognizer?.allowableMovement = 10.0
        recordButton.addGestureRecognizer(recordGestureRecognizer!)
        
        photoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapGestureRecognizer(_:)))
        photoTapGestureRecognizer?.numberOfTapsRequired = 1
        recordButton.addGestureRecognizer(photoTapGestureRecognizer!)
        photoTapGestureRecognizer?.require(toFail: recordGestureRecognizer!)
        
        // gestures
        gestureView = UIView(frame: screenBounds)
        if let gestureView = self.gestureView {
            gestureView.backgroundColor = .clear
            self.view.addSubview(gestureView)
            
            gestureView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            self.focusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFocusTapGestureRecognizer(_:)))
            if let focusTapGestureRecognizer = self.focusTapGestureRecognizer {
                focusTapGestureRecognizer.delegate = self
                focusTapGestureRecognizer.numberOfTapsRequired = 1
                gestureView.addGestureRecognizer(focusTapGestureRecognizer)
            }
        }
        
        view.addSubview(recordButton)
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        view.addSubview(itemsBadge)
        view.addSubview(itemsScrollView)
        view.addSubview(lightButton)
        view.addSubview(libraryButton)
        view.addSubview(nextButton)
        view.addSubview(thumbnailsView)
        view.addSubview(tipBubble)
        
        tipBubble.label.text = "Snap your first item. \rTap for image, hold to record."
        
        gradientView.snp.makeConstraints {
            $0.top.left.right.equalTo(view)
            $0.height.equalTo(130)
        }
        
        recordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
        }
        
        tipBubble.snp.makeConstraints {
            $0.centerX.equalTo(recordButton)
            $0.bottom.equalTo(recordButton.snp.top).offset(-14)
        }
        
        cancelButton.snp.makeConstraints {
            $0.left.equalTo(view).inset(23)
            $0.top.equalTo(view).inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(cancelButton)
        }
        
        doneButton.snp.makeConstraints {
            $0.right.equalTo(view).inset(23)
            $0.top.equalTo(view).inset(20)
        }
        
        itemsBadge.snp.makeConstraints {
            $0.right.equalTo(view).inset(14)
            $0.top.equalTo(view).inset(19)
            $0.height.equalTo(17)
            $0.width.greaterThanOrEqualTo(17)
        }
        
        itemsScrollView.snp.makeConstraints {
            $0.top.equalTo(63)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        lightButton.snp.makeConstraints {
            $0.right.equalTo(view).inset(20)
            $0.top.equalTo(160)
        }
        
        libraryButton.snp.makeConstraints {
            $0.centerY.equalTo(recordButton)
            $0.right.equalTo(recordButton.snp.left).offset(-80)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(recordButton)
            $0.left.equalTo(recordButton.snp.right).offset(80)
        }
        
        thumbnailsView.snp.makeConstraints {
            $0.bottom.equalTo(recordButton.snp.top).inset(-20)
            $0.height.equalTo(54)
            $0.left.right.equalTo(view)
        }
        
        let nextLevel = NextLevel.shared
        nextLevel.delegate = self
        nextLevel.deviceDelegate = self
        nextLevel.flashDelegate = self
        nextLevel.videoDelegate = self
        nextLevel.photoDelegate = self
        nextLevel.metadataObjectsDelegate = self
        nextLevel.videoConfiguration.preset = AVCaptureSession.Preset.hd1280x720
        nextLevel.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(10, preferredTimescale: 600)
        nextLevel.videoConfiguration.bitRate = 5500000
        nextLevel.videoConfiguration.maxKeyFrameInterval = 30
        nextLevel.videoConfiguration.profileLevel = AVVideoProfileLevelH264HighAutoLevel
        nextLevel.audioConfiguration.bitRate = 96000
        
        addItemInput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        guard NextLevel.shared.isRunning == false else { return }
        
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
           NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try NextLevel.shared.start()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.tipBubble.show()
                }
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        let nextLevel = NextLevel.shared
                        try nextLevel.start()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.tipBubble.show()
                        }
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        let nextLevel = NextLevel.shared
                        try nextLevel.start()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.tipBubble.show()
                        }
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NextLevel.shared.stop()
    }
    
    func addItemInput() {
        let newItemInputView = ItemCameraEditView()
        itemsScrollView.addSubview(newItemInputView)
        
        if itemInputViews.count > 0 {
            if let previousInputView = itemInputViews.last {
                newItemInputView.snp.makeConstraints {
                    $0.left.equalTo(previousInputView.snp.right).offset(40)
                    $0.width.equalTo(previousInputView)
                    $0.top.bottom.equalTo(0)
                }
            }
        } else {
            newItemInputView.snp.makeConstraints {
                $0.left.equalTo(20)
                $0.width.equalToSuperview().inset(20)
                $0.top.bottom.equalTo(0)
            }
        }
        
        itemInputViews.append(newItemInputView)
        itemsScrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(itemInputViews.count), height: 60)
        
        itemsScrollView.updateConstraints()
        itemsScrollView.layoutSubviews()
        nextButton.isEnabled = true
        
        itemsBadge.text = "\(itemInputViews.count)"
    }
    
    var itemIndex = Int(0)
    @objc func tappedNext() {
        if itemIndex < itemInputViews.count - 1 {
            itemIndex = itemIndex + 1
            var itemFrame = itemInputViews[itemIndex].frame
            itemFrame.origin.x = itemFrame.origin.x + 20
            itemsScrollView.scrollRectToVisible(itemFrame, animated: true)
        } else {
            itemIndex = 0
            var itemFrame = itemInputViews[itemIndex].frame
            itemFrame.origin.x = 0
            itemsScrollView.scrollRectToVisible(itemFrame, animated: true)
        }
        
    }
    
}
extension CameraViewController {
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
}

extension CameraViewController {
    
    internal func startCapture() {
        self.photoTapGestureRecognizer?.isEnabled = false
//        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
//            self.recordButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        }) { (completed: Bool) in
//        }
        
        NextLevel.shared.session?.reset()
        NextLevel.shared.record()
        
        recordButton.setProgress(progress: 1, animate: true)
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    internal func endCapture() {
        guard self.photoTapGestureRecognizer?.isEnabled == false else { return }
        
        self.photoTapGestureRecognizer?.isEnabled = true
        
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//            self.recordButton.transform = .identity
//        }) { (completed: Bool) in
//            NextLevel.shared.pause()
//        }
        
        recordButton.reset()
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
//        if let session = NextLevel.shared.session {
//            if session.clips.count > 1 {
//                session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
//                    if let url = url {
//                        self.saveVideo(withURL: url)
//                    } else if let _ = error {
//                        print("failed to merge clips at the end of capture \(String(describing: error))")
//                    }
//                })
//            } else if let lastClipUrl = session.lastClipUrl {
//                self.saveVideo(withURL: lastClipUrl)
//            } else if session.currentClipHasStarted {
//                session.endClip(completionHandler: { (clip, error) in
//                    if error == nil {
//                        self.saveVideo(withURL: (clip?.url)!)
//                    } else {
//                        print("Error saving video: \(error?.localizedDescription ?? "")")
//                    }
//                })
//            } else {
//                // prompt that the video has been saved
//                let alertController = UIAlertController(title: "Video Capture", message: "Not enough video captured!", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
    }
    
    internal func authorizePhotoLibaryIfNecessary() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .restricted:
            fallthrough
        case .denied:
            let alertController = UIAlertController(title: "Oh no!", message: "Access denied.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    
                } else {
                    
                }
            })
            break
        case .authorized:
            break
        @unknown default:
            fatalError("unknown authorization type")
        }
    }
    
}

extension CameraViewController {
    internal func saveVideo(withURL url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                    if success2 == true {
                        // prompt that the video has been saved
                        let alertController = UIAlertController(title: "Video Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // prompt that the video has been saved
                        let alertController = UIAlertController(title: "Oops!", message: "Something failed!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        })
    }
    
    internal func savePhoto(photoImage: UIImage) {
        let NextLevelAlbumTitle = "NextLevel"
        
        PHPhotoLibrary.shared().performChanges({
            
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }
            
        }, completionHandler: { (success1: Bool, error1: Error?) in
            
            if success1 == true {
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                        let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                        let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                        assetCollectionChangeRequest?.addAssets(enumeration)
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            DispatchQueue.main.async {
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    })
                }
            } else if let _ = error1 {
                print("failure capturing photo from video frame \(String(describing: error1))")
            }
            
        })
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        debugPrint(info)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController {
    @objc func tappedBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedFlash() {
        if NextLevel.shared.torchMode == .on {
            lightButton.setImage(UIImage(named: "flashlight"), for: .normal)
            NextLevel.shared.torchMode = .off
        } else {
            lightButton.setImage(UIImage(named: "flashlight-on"), for: .normal)
            NextLevel.shared.torchMode = .on
        }
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    @objc func tappedFlip() {
        NextLevel.shared.flipCaptureDevicePosition()
    }
    
    @objc func tappedAdd() {
    }
    
    @objc func tappedBackspace() {
    }
    
    @objc func tappedLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        imagePickerController.allowsEditing = true
        imagePickerController.videoMaximumDuration = 10
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func tappedDone() {
        let reviewVC = ReviewViewController()
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @objc func tappedPost() {
        self.endCapture()
    }
}

extension CameraViewController: UIGestureRecognizerDelegate {
    @objc internal func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            tipBubble.hide()
            startCapture()
//            self._panStartPoint = gestureRecognizer.location(in: self.view)
//            self._panStartZoom = CGFloat(NextLevel.shared.videoZoomFactor)
            break
        case .changed:
//            let newPoint = gestureRecognizer.location(in: self.view)
//            let scale = (self._panStartPoint.y / newPoint.y)
//            let newZoom = (scale * self._panStartZoom)
//            NextLevel.shared.videoZoomFactor = Float(newZoom)
            break
        case .ended:
            fallthrough
        case .cancelled:
            fallthrough
        case .failed:
            endCapture()
            fallthrough
        default:
            break
        }
    }
}

extension CameraViewController {
    @objc internal func handlePhotoTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // play system camera shutter sound
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        NextLevel.shared.capturePhotoFromVideo()
        tipBubble.hide()
    }
    
    @objc internal func handleFocusTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: self.previewView)

        if let focusView = self.focusView {
            var focusFrame = focusView.frame
            focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
            focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
            focusView.frame = focusFrame
            
            previewView?.addSubview(focusView)
            focusView.startAnimation()
        }
        
        let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointConverted(fromLayerPoint: tapPoint)
        NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
    }
    
}

extension CameraViewController: NextLevelDelegate {

    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: AVMediaType) {
    }
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
    }
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionWillStart")
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStart")
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStop")
    }
    
    // interruption
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
    }
    
    // mode
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelPreviewDelegate {
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopPreview(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelDeviceDelegate {

    // position, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
    }
    
    // format
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format) {
    }
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
    }
    
    // lens
    func nextLevel(_ nextLevel: NextLevel, didChangeLensPosition lensPosition: Float) {
    }
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopFocus(_  nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelFlashAndTorchDelegate {
    
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel) {
    }

}

extension CameraViewController: NextLevelVideoDelegate {

    // video zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
    }

    // video frame processing
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
    }
    
    // enabled by isCustomContextVideoRenderingEnabled
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
    }
    
    // video recording session
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        // called when a configuration time limit is specified
        self.endCapture()
    }
    
    // video frame photo

    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] as? Data,
            let photoImage = UIImage(data: photoData) {
            self.savePhoto(photoImage: photoImage)
            
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
    }
}

extension CameraViewController: NextLevelPhotoDelegate {
    
    // photo
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {

            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                    
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                               let photoImage = UIImage(data: data) {
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                    
            })
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
    }

    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, didFinishProcessingPhoto photo: AVCapturePhoto) {
    }
    
}

private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension CameraViewController {
    
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}

extension CameraViewController: NextLevelMetadataOutputObjectsDelegate {
    func metadataOutputObjects(_ nextLevel: NextLevel, didOutput metadataObjects: [AVMetadataObject]) {
        
    }
}
