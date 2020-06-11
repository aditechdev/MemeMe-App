//
//  ViewController.swift
//  MemeMe App
//
//  Created by aditya anand on 10/06/20.
//  Copyright © 2020 aditechdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    
    let textDelegate = TextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
            attributes(textField: topField)
            attributes(textField: bottomField)
            self.bottomField.delegate = textDelegate
            self.topField.delegate=textDelegate
            
        }
    
    func attributes(textField: UITextField)
    {
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = UITextField.BorderStyle.none
    }
    
    

    @IBAction func pickAnImage(_ sender: Any) {
        openImagePicker(UIImagePickerController.SourceType.photoLibrary)
        //let imagePickerController = UIImagePickerController()
        //imagePickerController.delegate = self
        //imagePickerController.sourceType = .photoLibrary
    //present(imagePickerController, animated: true,completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        openImagePicker(UIImagePickerController.SourceType.camera)

        //let imagePickerController = UIImagePickerController()
        //imagePickerController.delegate = self
        //imagePickerController.sourceType = .camera
        //if UIImagePickerController.isSourceTypeAvailable(.camera) {
        //present(imagePickerController, animated: true, completion: nil)
           // }
    
    }
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    @IBAction func bottom(_ sender: Any) {
        subscribeToKeyboardNotifications()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            if let picker = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
            {
                imagePickerView.contentMode = .scaleAspectFit
                imagePickerView.image = picker
                shareButton.isEnabled = imagePickerView.image != nil
                
            }
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    @objc func keyboardWillShow(_ notification:Notification) {
            if bottomField.isFirstResponder {
                view.frame.origin.y = 0 - getKeyboardHeight(notification)
            }
        }
        
        @objc func keyboardWillHide(_ notification:Notification) {
            
            view.frame.origin.y = 0
        }
        
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
        
    func subscribeToKeyboardNotifications() {
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        func unsubscribeFromKeyboardNotifications() {
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            
        }

        let memeTextAttributes: [String:Any] = [
            NSAttributedString.Key.strokeColor.rawValue: UIColor.black,
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
            NSAttributedString.Key.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth.rawValue: -6]
     

        
        struct Meme {
            var topText: String
            var bottomText: String
            var originalImage: UIImage
            var memedImage: UIImage
            
        }
        
        
        func generateMemedImage() -> UIImage {
            hideToolbars(true)
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            hideToolbars(false)
            return memedImage
            }
        func hideToolbars(_ hide: Bool) {
            toolbar.isHidden=hide
            navBar.isHidden=hide
            }
        
        func save() {
            let memedImage = generateMemedImage()
            _ = Meme(topText: topField.text!, bottomText: bottomField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        }
        
        @IBAction func activityView(_ sender: Any) {
            
            let memedImage = generateMemedImage()
            let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
                controller.completionWithItemsHandler = { activity, completed, items, error in
                if completed{

                    self.save()
                   self.dismiss(animated: true, completion: nil)
                    
                }
            }
       
            self.present(controller, animated: true, completion: nil)
        }
        
    }


    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    
    fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
}
