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
    
    required init?(coder aDecoder: (NSCoder!)){
        super.init(coder: aDecoder);
    }
    
    func setUp(){
        
        isActive = true
        screenSize = self.frame
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue);
        scaleFactor = UIScreen.mainScreen().scale
        let rv = bitmapInfo!;
        
        ctx = CGBitmapContextCreate(
            nil,
            Int(self.frame.size.width * scaleFactor!),
            Int(self.frame.size.height * scaleFactor!),
            8,
            Int(self.frame.size.width * scaleFactor! * 4),
            colorSpace!,
            rv.rawValue)
        
        CGContextSetFillColorWithColor(ctx, UIColor.clearColor().CGColor)
        //CGContextSetRGBFillColor(ctx!, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx!, CGRectMake(0, 0, screenSize.width * scaleFactor!, screenSize.height * scaleFactor!));
        self.setNeedsDisplay();
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(canDraw){
            
            if let touch = touches.first {
                
                draw(touch, next:true);
                
            }
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(canDraw){
            //if let touch = touches.first as! UITouch {
            if let touch = touches.first {
                draw(touch, next:false);
            }
        }
        
    }
    
    func draw(touch:UITouch, next:Bool){
        
        
        newPoint = touch.locationInView(self);
        
        print(newPoint)
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
    
    
    
    override func drawRect(rect: CGRect) {
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        let cacheImage:CGImageRef = CGBitmapContextCreateImage(ctx!)!;
        CGContextDrawImage(context, self.bounds, cacheImage);
    }
    
    
    
    func drawToCache(x:CGFloat, y:CGFloat, scl:CGFloat, emoji:CGImage){
        
        //let img = currImage
        let img = emoji;
        
        CGContextSaveGState(ctx!);
        
        //CGContextTranslateCTM(ctx, 0.0, CGFloat(currSize));
        CGContextScaleCTM(ctx!, 1.0, -1.0);
        
        let fnlSze = scl;
        
        let imageRect = CGRect(
            x:CGFloat(x-(fnlSze * scaleFactor!) * 0.5),
            y:CGFloat( -(y+(fnlSze * scaleFactor!) * 0.5) ),
            width:CGFloat(fnlSze * scaleFactor!),
            height:CGFloat(fnlSze * scaleFactor!));
        
        //CGContextDrawImage(ctx!, imageRect, currImage);
        CGContextDrawImage(ctx!, imageRect, img);
        
        CGContextRestoreGState(ctx!);
        
        self.setNeedsDisplay();
        
    }
    
    func undo(){
        
        clearContext();
        history.undo(self);
        
    }
    
    func redo(){
        
        clearContext();
        history.redo(self);
        
    }
    
    func clearContext(){
        
        CGContextClearRect(self.ctx!, CGRectMake(0 , 0, self.screenSize.width*self.scaleFactor!, self.screenSize.height*self.scaleFactor!));
        CGContextSetFillColorWithColor(self.ctx, UIColor.clearColor().CGColor)
        CGContextFillRect(self.ctx!, CGRectMake(0, 0, self.screenSize.width * self.scaleFactor!, self.screenSize.height * self.scaleFactor!));
        self.setNeedsDisplay();
        
    }

    
    func setDrawImg(img:String, sze:CGFloat){
        //currImageNumber = Int(img)!
        currImage = UIImage(named: "emojis/\(img).png")?.CGImage;
        currSize = sze;
    }
    
    func destroyImage(){
        history.newDrawing();
        let clearFrame = CGRectMake(0 , 0, screenSize.width*scaleFactor!, screenSize.height*scaleFactor!-(355.5*scaleFactor!))
        let clear = UIImageView(frame: clearFrame)
        clear.backgroundColor = UIColor.whiteColor()
        clear.alpha = 0;
        clear.hidden = false
        self.addSubview(clear)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            clear.alpha =
            1;
        })
        
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            clear.hidden = true;
            /*
            CGContextClearRect(self.ctx!, CGRectMake(0 , 0, self.screenSize.width*self.scaleFactor!, self.screenSize.height*self.scaleFactor!));
            CGContextSetRGBFillColor(self.ctx!, 1.0, 1.0, 1.0, 1.0);
            CGContextFillRect(self.ctx!, CGRectMake(0, 0, self.screenSize.width * self.scaleFactor!, self.screenSize.height * self.scaleFactor!));
            self.setNeedsDisplay();
            */
            self.clearContext();
        }
    }
    
    
    func getImage()->NSData{
        
        let ctxImg = UIImage(CGImage: CGBitmapContextCreateImage(ctx!)!).CGImage;
        
        let output = CGBitmapContextCreate(nil,Int(screenSize.width * scaleFactor!),Int(screenSize.height * scaleFactor!),8,Int(screenSize.width * scaleFactor! * 4),colorSpace!,bitmapInfo!.rawValue);
        
        CGContextSaveGState(output);
        
        CGContextTranslateCTM(output, 0, screenSize.height * scaleFactor!);
        CGContextScaleCTM(output, 1.0, -1.0);
        
        let imageRect = CGRect(x:0.0, y:0.0, width:screenSize.width * scaleFactor!, height:screenSize.height * scaleFactor!);
        
        CGContextDrawImage(output, imageRect, ctxImg);
        
        let imageRef = CGBitmapContextCreateImage(output);
        let image = UIImage(CGImage: imageRef!);
        let imageData = UIImagePNGRepresentation(image);
        
        CGContextRestoreGState(output);
        
        return imageData!;
        
    }
    
}
