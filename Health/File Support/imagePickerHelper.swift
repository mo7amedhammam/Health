//
//  imagePickerHelper.swift
//  Health
//
//  Created by wecancity on 12/09/2023.
//

import UIKit

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var image: UIImage?
    private let viewController: UIViewController
    private var imageReceivedCallback: ((UIImage?) -> Void)?

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func showImagePicker(completion: @escaping (UIImage?) -> Void) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "استخدم الكاميرا", style: .default) { [weak self] _ in
            guard let self = self, UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            imagePicker.sourceType = .camera
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }
        
        let galleryAction = UIAlertAction(title: "من مكتبه الصور", style: .default) { [weak self] _ in
            guard let self = self else { return }
            imagePicker.sourceType = .photoLibrary
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
        // Set the callback to be executed when an image is received
        self.imageReceivedCallback = completion
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            imageReceivedCallback?(nil)
            return
        }
        
        // Compress the selected image
        let compressionQuality: CGFloat = 0.5 // Set the compression quality to 50%
        guard let compressedImage = selectedImage.jpegData(compressionQuality: compressionQuality),
              let compressedUIImage = UIImage(data: compressedImage) else {
            imageReceivedCallback?(nil)
            return
        }
        
        image = compressedUIImage
        imageReceivedCallback?(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageReceivedCallback?(nil)
    }
}

