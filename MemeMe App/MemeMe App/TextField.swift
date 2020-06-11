//
//  TextField.swift
//  MemeMe App
//
//  Created by aditya anand on 11/06/20.
//  Copyright © 2020 aditechdev. All rights reserved.
//

import Foundation
import UIKit

class TextField : NSObject, UITextFieldDelegate {
    

    func textFieldDidBeginEditing(_ topField: UITextField) {
        if topField.text=="TOP" || topField.text=="BOTTOM" {
            topField.text = ""
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
