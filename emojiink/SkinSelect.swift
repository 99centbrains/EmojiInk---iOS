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
    
    var emojiView = UIView()
    var t:CGFloat = 0.0
    var dif:CGFloat = 0.0
    var parentVC:ScaleView!
    
    init(pnt:CGPoint, scl:CGPoint, currEmoji:Int, parent:ScaleView){
        
        parentVC = parent;
        let rct = CGRect(x: 0.0, y: 0.0, width: scl.x, height: scl.y);
        super.init(frame:rct);
        self.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.5);
        
        let esze:CGFloat = 50.0
        
        let emojiRct = CGRect(x: pnt.x, y: pnt.y, width: esze, height: esze);
        emojiView = UIView(frame: emojiRct);
        self.addSubview(emojiView);
        
        
        let img = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: esze, height: esze));
        img.image = UIImage(named: "emoji/\(currEmoji).png");
        emojiView.addSubview(img);
        
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if let touch = touches.first {
            //handleMove(touch, first:true);
        //}
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            handleMove(touch, first:false);
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        killSelf();
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        killSelf();
        
    }
    func killSelf(){
        print("asdf");
        parentVC.killSkinSelect()
    }
    
    func handleMove(_ touch:UITouch, first:Bool ){
        
        let tpos = touch.location(in: self).y;
        
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
