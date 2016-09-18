//
//  SkinSlider.swift
//  emoji.ink
//
//  Created by Vince Mckelvie on 1/20/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import UIKit
import Foundation
import Darwin

class SkinSlider : UIView {
    
    var cv:UICollectionView!; // collection view to manipulate scroll view
    var parent:EmojiSelectViewController!;
    var currentDir:Int = 0;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self);
            doScroll(pos);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self);
            doScroll(pos);
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func doScroll(_ location:CGPoint){
        
        let nrml:Double = Double( (location.y / self.bounds.height)*6 );
        var num:Int = Int(floor(nrml));
        print(num);
        if(num>5){
            num = 5;
        }
        if(num<0){
            num = 0;
        }
        var someArray = [String]()
        let assets = AssetManager().getAssetsForDir("/emoji/skin/\(num)/")
        for i in assets {
            someArray.append(AssetManager().getFullAsset(i, dir: "/emoji/skin/\(num)/"))
        }
        parent!.emojis = someArray
        if(num != currentDir){
            cv!.reloadSections(IndexSet(integer: 0))
            currentDir = num;
        }
        //cv!.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
        
        
    }

}

