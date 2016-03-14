//
//  SkinSelect.swift
//  emoji.ink
//
//  Created by Vince Mckelvie on 10/29/15.
//  Copyright © 2015 tight corp. All rights reserved.
//

import UIKit

class SkinSelect: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var emojiView = UIView?();
    var t:CGFloat = 0.0;
    var dif:CGFloat = 0.0;
    var parentView = ScaleView?();
    
    init(pnt:CGPoint, scl:CGPoint, currEmoji:Int, parent:ScaleView){
        
        parentView = parent;
        let rct = CGRectMake(0.0, 0.0, scl.x, scl.y);
        super.init(frame:rct);
        self.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.5);
        
        let esze:CGFloat = 50.0
        
        let emojiRct = CGRectMake(pnt.x, pnt.y, esze, esze);
        emojiView = UIView(frame: emojiRct);
        self.addSubview(emojiView!);
        
        
        let img = UIImageView(frame: CGRectMake(0.0, 0.0, esze, esze));
        img.image = UIImage(named: "emoji/\(currEmoji).png");
        emojiView!.addSubview(img);
        
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //if let touch = touches.first {
            //handleMove(touch, first:true);
        //}
    
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            handleMove(touch, first:false);
        }
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        killSelf();
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        killSelf();
        
    }
    func killSelf(){
        print("asdf");
        parentView!.killSkinSelect();
    }
    
    func handleMove(touch:UITouch, first:Bool ){
        
        let tpos = touch.locationInView(self).y;
        
        //if(first){
            //t = tpos;
            dif = tpos;
        //}else{
        if(!first){
            dif = t - tpos;
        }
        
        print("dif = \(dif)");
        
        handleEmojiSwap();
        
    }
    
    func handleEmojiSwap(){
        
    }

}
