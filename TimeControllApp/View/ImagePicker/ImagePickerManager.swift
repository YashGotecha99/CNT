//
//  ImagePickerManager.swift
//  YoomApplication
//
//  Created by sandeep on 06/01/22.
//

import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: LocalizationKey.chooseAnImage.localizing(), message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage, String) -> ())?;

    override init(){
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        let cameraAction = UIAlertAction(title: LocalizationKey.camera.localizing() , style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: LocalizationKey.gallery.localizing(), style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: LocalizationKey.warning.localizing(), message: LocalizationKey.youdontHaveCamera.localizing(), preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: LocalizationKey.ok.localizing(), style: .default){
                UIAlertAction in
            }
            alert.addAction(ok)
            self.viewController!.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}

    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let source = picker.sourceType
        print("source", source)
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
//        guard let mediaMetadata = info[.mediaURL] as? UIImage else {
//            return
//           // fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
       
        if source != .camera{
            guard let url_Path = info[.imageURL] as? URL else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            let str_Path = url_Path.lastPathComponent
            pickImageCallback?(image, str_Path)
        }else{
            guard let mediaMetadata = info[.mediaMetadata] as? [String:Any] else {
               // fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                return
            }
            if  let tiff = mediaMetadata["{TIFF}"] as? [String:Any]{
                if  let name = tiff["DateTime"] as? String{
                CameraImageManager.saveImage(imageName: "\(name).jpg", image: image)
                let nameURL = CameraImageManager.getImagePathFromDiskWith(fileName: "\(name).jpg")
                let str_Path = nameURL?.lastPathComponent ?? ""
                pickImageCallback?(image, str_Path)
                }
            }
           
        }
       
    }


    @objc private func image(path: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        debugPrint(path) // That's the path you want
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}

class CameraImageManager {

   static func saveImage(imageName: String, image: UIImage) {

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }

    static func getImagePathFromDiskWith(fileName: String) -> URL? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            return imageUrl
        }

        return nil
    }

   static func loadImageFromDiskWith(fileName: String) -> UIImage? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }

}

