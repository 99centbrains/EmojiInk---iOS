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
    
    @objc optional func photoTrash()
    @objc optional func photoOverlayToggle(_ toggle:Bool)
    
    @objc optional func photoMoveScale(_ toggle:Bool)
    
}

class PhotoEditViewController: UIViewController {
    
    @IBOutlet weak var ibo_btnMove:UIButton!
    @IBOutlet weak var ibo_btnRotate:UIButton!
    
    var delegate:PhotoEditViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func iba_overlayToggle(_ id:UISwitch){
        
        delegate.photoOverlayToggle!(id.isOn)
    
    }
    
    @IBAction func iba_funcTrashPic(){
        
        delegate.photoTrash!()
    
    }
    
    
    @IBAction func iba_scaleMovePic(_ id:UIButton){
        id.isSelected = true
        
        if id.tag == 0 {// SCALE
            delegate.photoMoveScale!(true)
            ibo_btnMove.isSelected = false
         return
        }
        
        if id.tag == 1 {// MOVE
            delegate.photoMoveScale!(false)
            ibo_btnRotate.isSelected = false
            return
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
