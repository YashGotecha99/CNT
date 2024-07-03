//
// ImageManager.swift
// Cash Clicker
//
// Created by Aman preet on 3/7/19.
// Copyright © 2019 Aman preet. All rights reserved.
//

import Foundation
import UIKit
import AVKit

import SwiftUI
import PhotosUI

protocol ImageManagerDelegate {
    func didImageSelect(image:UIImage, url:URL?, mediaType:String?)
    func didImageCancel()
}

class ImageManager: NSObject {
    var imageDelegate:ImageManagerDelegate? = nil
    let imageController = UIImagePickerController()
    
    var imageRequestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        return options
    }
    
    class func manager() -> ImageManager {
        struct Static {
            static let manager = ImageManager()
        }
        
        return Static.manager
    }
    
    override init() {
        super.init()
        imageController.delegate = self
    }
}

// MARK:-ImagePicker Delegate Methods
extension ImageManager : UIImagePickerControllerDelegate,UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if #available(iOS 14.6, *) {
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            // Use UIImage
                            print("Selected image: \(image)")
                            self.imageDelegate?.didImageSelect(image: image, url: nil, mediaType: nil)
                        }
                    }
                })
            }
            return
        } else {
            if let assetId = results.first?.assetIdentifier,
               let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject
            {
                print("asset is \(asset)")
                print("asset location is \(String(describing: asset.location))")
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageRequestOptions, resultHandler: { (image, info) in
                    print("requested image is \(String(describing: image))")
                    if let selectedImage = image {
                        self.imageDelegate?.didImageSelect(image: selectedImage, url: nil, mediaType: nil)
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.image" {
                if let selectedImage = info[.editedImage] as? UIImage {
                    self.imageDelegate?.didImageSelect(image: selectedImage, url: info[.imageURL] as? URL, mediaType: mediaType)
                }
            } else if mediaType == "public.movie" {
                if let outputVideo = info[.mediaURL] as? URL {
                    self.imageDelegate?.didImageSelect(image: UIImage(), url: outputVideo, mediaType: mediaType)
                }
            }
        }
        // Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
        self.imageDelegate?.didImageCancel()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func decreaseImageQuality(img: UIImage) -> UIImage {
        let size = __CGSizeApplyAffineTransform(img.size, CGAffineTransform.init(scaleX: 0.2, y: 0.2))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    private func getThnumbnail(url:URL) -> UIImage {
        let asst = AVAsset(url: url)
        let imgGen = AVAssetImageGenerator(asset: asst)
        imgGen.appliesPreferredTrackTransform = true
        do {
            let cgImage = try imgGen.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnailImg = UIImage(cgImage: cgImage)
            return thumbnailImg
        } catch {
            print("thumnail generation error - ",error.localizedDescription)
        }
        return UIImage()
    }
}

extension ImageManager {
    func openCamera(vc: UIViewController, mediaType: [String]) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imageController.sourceType = UIImagePickerController.SourceType.camera
            imageController.allowsEditing = true
            imageController.mediaTypes = mediaType
            vc.present(imageController, animated: true, completion: nil)
        } else {
            // showAlert(title: "Error", message: "You don't have camera")
        }
    }
    
    // MARK:- Open gallery
    func openGallary(vc: UIViewController, mediaType: [String]) {
        if #available(iOS 14.0, *){
            let photoLibrary = PHPhotoLibrary.shared()
            let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            vc.present(picker, animated: true)
        } else {
            imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
            imageController.allowsEditing = true
            imageController.mediaTypes = mediaType
            vc.present(imageController, animated: true, completion: nil)
        }
    }
}

