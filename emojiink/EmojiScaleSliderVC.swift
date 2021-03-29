//
//  EmojiScaleViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/17/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit

class EmojiScaleSliderVC: UIViewController {
    
    var selectedEmoji:UIImage!
    
    var delegate:EmojiSelectViewControllerDelegate!
    
    @IBOutlet weak var ibo_emojiSizeSmall:UIImageView!
    @IBOutlet weak var ibo_emojiSizeLarge:UIImageView!
    @IBOutlet weak var ibo_emojiSelected:UIImageView!
    
    @IBOutlet weak var ibo_emojiSlider:UISlider!
    var emojiScale:CGFloat = 1.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ibo_emojiSlider.value = Float(emojiScale)
        ibo_emojiSelected.transform = CGAffineTransform(scaleX: CGFloat(1), y: CGFloat(1))
        emojiScale = emojiScale * 40
    }
    

    func setupIcons(){
        
        if selectedEmoji != nil {
            ibo_emojiSizeSmall.image = selectedEmoji
            ibo_emojiSizeLarge.image = selectedEmoji
            ibo_emojiSelected.image = selectedEmoji
        }
    }
    
    @IBAction func iba_sliderAdjust(slider: UISlider){
        
        let scale = slider.value
        emojiScale = 40 * CGFloat(scale)
        ibo_emojiSelected.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        self.delegate.emojiDidFinish?(selectedEmoji, size: self.emojiScale)

    }
    
    func dismissThis() {
        self.delegate.emojiDidFinish?(selectedEmoji, size: self.emojiScale)
    }
    
}
