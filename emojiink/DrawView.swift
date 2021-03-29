//
//  DrawView.swift
//  Emoji.inkTest
//
//  Created by Vince McKelvie on 2/14/15.
//  Copyright (c) 2015 BetterMagic. All rights reserved.
//

import UIKit
import Foundation

class DrawView : UIView {
    
    var isActive = false
    var isTouch = false;
    var force:CGFloat = 0.0;
    var screenSize: CGRect!
    var newPoint:CGPoint = CGPoint(x:0.0, y:0.0);
    var currImage:CGImage!
    //var currImage = CGImage()!;//named: "0")?.CGImage;
    var currSize:CGFloat = 40.0;
    var ctx:CGContext?;
    var history = EmojiHistory();
    
    //var outputCtx:CGContext!;
    
    var colorSpace:CGColorSpace?;
    var bitmapInfo:CGBitmapInfo?;
    var canDraw:Bool = true;
    var scaleFactor:CGFloat?;
    
    var btn_undo:UIButton!
    var btn_redo:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    func setUp(){
        
        isActive = true
        screenSize = self.frame
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue);
        scaleFactor = UIScreen.main.scale
        let rv = bitmapInfo!;
        
        ctx = CGContext(
            data: nil,
            width: Int(self.frame.size.width * scaleFactor!),
            height: Int(self.frame.size.height * scaleFactor!),
            bitsPerComponent: 8,
            bytesPerRow: Int(self.frame.size.width * scaleFactor! * 4),
            space: colorSpace!,
            bitmapInfo: rv.rawValue)
        
        ctx?.setFillColor(UIColor.clear.cgColor)
        //CGContextSetRGBFillColor(ctx!, 1.0, 1.0, 1.0, 1.0);
        ctx!.fill(CGRect(x: 0, y: 0, width: screenSize.width * scaleFactor!, height: screenSize.height * scaleFactor!));
        self.setNeedsDisplay();
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(canDraw){
            
           
            
            btn_redo.isSelected = false
            
            print("history.emo.count \(history.emo.count)")
            if (history.emo.count >= 0){
                btn_undo.isSelected = true
            }
            
            if let touch = touches.first {
                
                draw(touch, next:true);
                
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(canDraw){
            //if let touch = touches.first as! UITouch {
            if let touch = touches.first {
                draw(touch, next:false);
            }
        }
        
    }
    
    func draw(_ touch:UITouch, next:Bool){
        
        
        newPoint = touch.location(in: self);
        
        //print(newPoint)
        newPoint.x *= scaleFactor!;
        newPoint.y *= scaleFactor!;
        
        if(isTouch){//3d touch
            if #available(iOS 9.0, *) {
                force = -3.0+touch.force;
                force *= 10.0;
            } else {
                force = 0.0;
            };
            
        }else{
            force = 0.0;
        }
        
        if(next){
            history.nextTap(newPoint.x, y: newPoint.y, scl: currSize + force, emoji: currImage);
        }else{
            history.addEmoji(newPoint.x, y: newPoint.y, scl: currSize + force, emoji: currImage)
        }
        
        self.drawToCache(newPoint.x, y:newPoint.y, scl: currSize + force, emoji: currImage);
    
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        let cacheImage:CGImage = ctx!.makeImage()!;
        context.draw(cacheImage, in: self.bounds);
    }
    
    
    
    func drawToCache(_ x:CGFloat, y:CGFloat, scl:CGFloat, emoji:CGImage){
        
        //let img = currImage
        let img = emoji;
        
        ctx!.saveGState();
        
        //CGContextTranslateCTM(ctx, 0.0, CGFloat(currSize));
        ctx!.scaleBy(x: 1.0, y: -1.0);
        
        let fnlSze = scl;
        
        let imageRect = CGRect(
            x:CGFloat(x-(fnlSze * scaleFactor!) * 0.5),
            y:CGFloat( -(y+(fnlSze * scaleFactor!) * 0.5) ),
            width:CGFloat(fnlSze * scaleFactor!),
            height:CGFloat(fnlSze * scaleFactor!));
        
        //CGContextDrawImage(ctx!, imageRect, currImage);
        ctx!.draw(img, in: imageRect);
        
        ctx!.restoreGState();
        
        self.setNeedsDisplay();
        
    }
    
    func undo(){
        
        clearContext();
        history.undo(self);
        
        print("CURRENT: \(history.current)")
        print("MAX: \(history.max)")
        
        
        if (history.current > history.max){
            btn_redo.isSelected = true
        }
        
        if (history.max < 0){
            btn_undo.isSelected = false
        }
        
    }
    
    func redo(){
        
        print("CURRENT: \(history.current)")
        print("MAX: \(history.max)")
        
        if (history.max == history.current - 1){
            btn_redo.isSelected = false
        }
        
        btn_undo.isSelected = true
        
        clearContext();
        history.redo(self);
        
    }
    
    func clearContext(){
        
        self.ctx!.clear(CGRect(x: 0 , y: 0, width: self.screenSize.width*self.scaleFactor!, height: self.screenSize.height*self.scaleFactor!));
        self.ctx?.setFillColor(UIColor.clear.cgColor)
        self.ctx!.fill(CGRect(x: 0, y: 0, width: self.screenSize.width * self.scaleFactor!, height: self.screenSize.height * self.scaleFactor!));
        self.setNeedsDisplay();
        
    }

    
    func setDrawImg(_ img:String, sze:CGFloat){
        //currImageNumber = Int(img)!
        currImage = UIImage(named: "emojis/\(img).png")?.cgImage;
        currSize = sze;
    }
    
    func destroyImage(){
        
        btn_redo.isSelected = false
        btn_undo.isSelected = false
        
        
        history.newDrawing();
        let clearFrame = CGRect(x: 0 , y: 0, width: screenSize.width*scaleFactor!, height: screenSize.height*scaleFactor!-(355.5*scaleFactor!))
        let clear = UIImageView(frame: clearFrame)
        clear.backgroundColor = UIColor.white
        clear.alpha = 0;
        clear.isHidden = false
        self.addSubview(clear)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            clear.alpha =
            1;
        })
        
        let delay = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            clear.isHidden = true;
            /*
            CGContextClearRect(self.ctx!, CGRectMake(0 , 0, self.screenSize.width*self.scaleFactor!, self.screenSize.height*self.scaleFactor!));
            CGContextSetRGBFillColor(self.ctx!, 1.0, 1.0, 1.0, 1.0);
            CGContextFillRect(self.ctx!, CGRectMake(0, 0, self.screenSize.width * self.scaleFactor!, self.screenSize.height * self.scaleFactor!));
            self.setNeedsDisplay();
            */
            self.clearContext();
        }
    }
    
    
    func getImage()->Data{
        
        let ctxImg = UIImage(cgImage: ctx!.makeImage()!).cgImage;
        
        let output = CGContext(data: nil,width: Int(screenSize.width * scaleFactor!),height: Int(screenSize.height * scaleFactor!),bitsPerComponent: 8,bytesPerRow: Int(screenSize.width * scaleFactor! * 4),space: colorSpace!,bitmapInfo: bitmapInfo!.rawValue);
        
        output?.saveGState();
        
        output?.translateBy(x: 0, y: screenSize.height * scaleFactor!);
        output?.scaleBy(x: 1.0, y: -1.0);
        
        let imageRect = CGRect(x:0.0, y:0.0, width:screenSize.width * scaleFactor!, height:screenSize.height * scaleFactor!);
        
        output?.draw(ctxImg!, in: imageRect);
        
        let imageRef = output?.makeImage();
        let image = UIImage(cgImage: imageRef!);
        let imageData = image.pngData();
        
        output?.restoreGState();
        
        return imageData!;
        
    }
    
}
