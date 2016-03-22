//
//  SkinSlider.swift
//  emoji.ink
//
//  Created by Vince Mckelvie on 1/20/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import UIKit
import Foundation

class ColorSlider : UIView {
    
    var cv:UICollectionView!; // collection view to manipulate scroll view
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.locationInView(self);
            doScroll(pos);
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.locationInView(self);
            doScroll(pos);
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    func doScroll(location:CGPoint){
        
        let nrml = location.y / self.bounds.height;
        print(nrml);
        
        let hght = cv!.collectionViewLayout.collectionViewContentSize().height;
        
        var yScrollPos:CGFloat = CGFloat( (hght)  * nrml);
        
        if(yScrollPos<0.0){
            yScrollPos = 0.0;
        }
        
        if(yScrollPos>hght){
            yScrollPos = hght;
        }
        
        cv!.contentOffset = CGPointMake(0,yScrollPos);
        
    }

}

