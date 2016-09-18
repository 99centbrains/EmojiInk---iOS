//
//  EmojiScaleViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/17/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit

class EmojiScaleViewController: UIViewController {
    
    var selectedEmoji:UIImage!
    
    @IBOutlet weak var ibo_emojiSizeSmall:UIImageView!
    @IBOutlet weak var ibo_emojiSizeLarge:UIImageView!
    @IBOutlet weak var ibo_emojiSelected:UIImageView!
    
    @IBOutlet weak var ibo_emojiSlider:UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setValueSlider(_ value:CGFloat){
        
        ibo_emojiSlider.value = Float(value)
   
    }
    
    
    func setupIcons(){
        
        if selectedEmoji != nil {
            
            ibo_emojiSizeSmall.image = selectedEmoji
            ibo_emojiSizeLarge.image = selectedEmoji
            ibo_emojiSelected.image = selectedEmoji
            
            
        }
        
    }
    
    
    
}
