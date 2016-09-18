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
        
        let nrml = location.y / self.bounds.height;
        print(nrml);
        
        let hght = cv!.collectionViewLayout.collectionViewContentSize.height;
        
        var yScrollPos:CGFloat = CGFloat( (hght)  * nrml);
        
        if(yScrollPos<0.0){
            yScrollPos = 0.0;
        }
        
        if(yScrollPos>hght){
            yScrollPos = hght;
        }
        
        cv!.contentOffset = CGPoint(x: 0,y: yScrollPos);
        
    }

}

