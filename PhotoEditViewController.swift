//
//  PhotoEditViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/13/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit
@objc protocol PhotoEditViewControllerDelegate {
    
    optional func photoTrash()
    optional func photoOverlayToggle(toggle:Bool)
    
    optional func photoMoveScale(toggle:Bool)
    
}

class PhotoEditViewController: UIViewController {
    
    @IBOutlet weak var ibo_btnMove:UIButton!
    @IBOutlet weak var ibo_btnRotate:UIButton!
    
    var delegate:PhotoEditViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func iba_overlayToggle(id:UISwitch){
        
        delegate.photoOverlayToggle!(id.on)
    
    }
    
    @IBAction func iba_funcTrashPic(){
        
        delegate.photoTrash!()
    
    }
    
    
    @IBAction func iba_scaleMovePic(id:UIButton){
        id.selected = true
        
        if id.tag == 0 {// SCALE
            delegate.photoMoveScale!(true)
            ibo_btnMove.selected = false
         return
        }
        
        if id.tag == 1 {// MOVE
            delegate.photoMoveScale!(false)
            ibo_btnRotate.selected = false
            return
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}