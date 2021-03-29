//
//  EmojiSelectViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/11/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit

@objc protocol EmojiTextPickerVCDelegate {
    @objc optional func textEmojiDidFinish(_ emoji:UIImage)
}

class EmojiTextPickerVC: UIViewController,  UITextFieldDelegate{
    @IBOutlet weak var ibo_TextLabel: UITextField!
    @IBOutlet weak var ibo_UIView: UIView!
    
    var delegate:EmojiTextPickerVCDelegate!
    
    override func viewDidLoad() {
        ibo_TextLabel.delegate = self
        ibo_TextLabel.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ibo_TextLabel.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.renderMoji { (image) in
            self.delegate.textEmojiDidFinish?(image)
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
    
    func renderMoji(_ callback: @escaping (UIImage) -> ()) {
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            UIGraphicsBeginImageContextWithOptions(self.ibo_UIView.frame.size, false, 0.0)
            self.ibo_UIView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            callback(drawImage!)
        }
    }
}

