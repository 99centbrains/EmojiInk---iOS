//
//  ScaleView.swift
//  Emoji.inkTest
//
//  Created by Vince McKelvie on 2/14/15.
//  Copyright (c) 2015 BetterMagic. All rights reserved.
//

import UIKit

class ScaleView: UIView{
   
    //var animalPack:SKProduct!;
    
    var emojiButtons = [UIButton]();
    let screenSize: CGRect = UIScreen.mainScreen().bounds;
    
    var currImage = "453";
    var currScale:CGFloat = 40.0;
    
    var mainView = MainViewController?();
    var emojiView = UIView?();
    var sliderHolder = UIView?();
    var killButton = UIButton?();
    var emojiScroller = UIButton?();
    var emojiPreview = UIImageView?();
    var emojiSlider = UISlider?();
    var emojiHolder = UIScrollView?();
    var scrollHeight:CGFloat?;
    var btnSze:CGFloat?;
    var packs = Packs();
    var userDefaults = NSUserDefaults.standardUserDefaults();
    var labelLeft = UIImageView?();
    var labelRight = UIImageView?();
    
    
    required init?(coder aDecoder: (NSCoder!)){
        super.init(coder: aDecoder);
        
        //resetUserDefault();
        
        let bools:[String:Bool]? = userDefaults.objectForKey("purchases") as! [String:Bool]?;
    
        
        if(bools != nil){
            packs.setBools(bools!);
        }else{
            //if havent saved set
            resetUserDefault();
        }
        
        emojiView = self;
        emojiView!.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        emojiView!.hidden = true;
        
        
        emojiView!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0);
        
        var yPos:CGFloat = 0;
        let marg:CGFloat = 5.0;
        let sze = screenSize.width/8;

        killButton = UIButton(frame: CGRectMake(0, 0, screenSize.width, screenSize.height));
        killButton!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3);
        killButton!.addTarget(self, action: "killSelfAction:", forControlEvents: UIControlEvents.TouchUpInside);
        emojiView!.addSubview(killButton!);
        
        //CGRect(x:50.0, y:screenSize.height * 0.5 - 30, width:screenSize.width-100, height:20.0) );
        sliderHolder = UIView(frame: CGRectMake(0, screenSize.height * 0.5 - 40, screenSize.width, screenSize.height * 0.5 + 30));
        
        sliderHolder!.frame = CGRectMake(0, screenSize.height, screenSize.width, screenSize.height * 0.5 + 30);
        
        emojiView!.addSubview(sliderHolder!);
        sliderHolder?.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0);
        
        //emojiHolder = UIScrollView(frame: CGRectMake(0, screenSize.height * 0.5, screenSize.width - sze, screenSize.height * 0.5));
        emojiHolder = UIScrollView(frame: CGRectMake(0, 40, screenSize.width - sze, screenSize.height * 0.5));
        emojiHolder!.showsVerticalScrollIndicator = false;
        emojiHolder!.backgroundColor = UIColor.whiteColor();
        sliderHolder!.addSubview(emojiHolder!);
        
        for(var i = 0; i<=849; i++){
            
            let counter = CGFloat (i % 7);
            
            let x = counter * sze + marg;
            let y = yPos + marg;
            let btn = UIButton(frame: CGRectMake(x, y, sze - marg * 2.0, sze - marg * 2.0 ));
            
            btn.setImage(UIImage(named: "\(i)"), forState: .Normal);
            
            btn.tag = i;
            
            let isInPack:Bool = packs.isInPack( i );
            if(isInPack == true){
                if(!packs.isPackPurchased(i)){
                    btn.alpha = 0.5;
                }
            }
            
            btn.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside);
            
            emojiHolder!.addSubview(btn);
            emojiButtons.append(btn);
            
            if( Int(counter) == 6 ){
                yPos += sze;
            }
        }
        
        btnSze = CGFloat(sze);
        scrollHeight = CGFloat(yPos+sze);
        emojiHolder!.contentSize = CGSize(width: screenSize.width - sze, height: scrollHeight!);
        
        emojiPreview = UIImageView(frame:CGRectMake( (screenSize.width * 0.5) - (currScale * 0.5), (screenSize.height * 0.25) - (currScale * 0.5),
            currScale, currScale) );
        emojiPreview!.image = UIImage(named: currImage);
        emojiView!.addSubview(emojiPreview!);
        emojiPreview!.alpha = 0;
        
        emojiSlider = UISlider(frame: CGRect(x:50.0, y:10, width:screenSize.width-100, height:20.0) );
        sliderHolder!.addSubview(emojiSlider!);
        emojiSlider!.minimumValue = 5;
        emojiSlider!.maximumValue = 120;
        emojiSlider!.value = 40;
        emojiSlider!.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged);
        
        emojiScroller = UIButton(type: UIButtonType.Custom) as UIButton;
        emojiScroller!.frame = CGRectMake(screenSize.width - sze + marg*2.0 , screenSize.height, CGFloat(sze), screenSize.height * 0.5);
        
        emojiScroller!.setBackgroundImage(UIImage(named: "colorgrad"), forState: .Normal);

        emojiView!.addSubview(emojiScroller!);
        
        emojiScroller!.addTarget(self, action: "scrollerActionDrag:event:", forControlEvents: .TouchDragInside);
        emojiScroller!.addTarget(self, action: "scrollerActionDown:event:", forControlEvents: .TouchDown);
        emojiScroller!.addTarget(self, action: "scrollerActionDown:event:", forControlEvents: .TouchDragEnter);
        emojiScroller!.addTarget(self, action: "scrollerActionUp:event:", forControlEvents: .TouchUpInside);
        emojiScroller!.addTarget(self, action: "scrollerActionUp:event:", forControlEvents: .TouchCancel);
        emojiScroller!.addTarget(self, action: "scrollerActionUp:event:", forControlEvents: .TouchDragExit);
    
        labelLeft = UIImageView(frame: CGRectMake(15.0, 10, 20.0, 20.0));
        labelLeft!.image = UIImage(named: "453");
        sliderHolder!.addSubview(labelLeft!);
        
        labelRight = UIImageView(frame: CGRectMake(screenSize.width - 40, 5, 30.0, 30.0));
        labelRight!.image = UIImage(named: "453");
        sliderHolder!.addSubview(labelRight!);

    }
    
    func unlockProduct(str:String){
        
        var bools = packs.packsPurchased;
        var arr:[Int]?;
        
        if(str != "all"){
            bools[str] = true;
            arr = packs.numbersDict[str];
        }else{
            for (pack, _) in bools {
                if(pack != "100 Pack"){
                    bools[pack] = true;
                }
            }
            arr = packs.payAll;
        }
        
        for i in arr! {
            emojiButtons[i].alpha = 1.0;
        }
        
        packs.packsPurchased = bools;
        userDefaults.setObject(packs.packsPurchased, forKey: "purchases");
        userDefaults.synchronize();

    }
    
    func setMainController(mvc:MainViewController){
        mainView = mvc;
    }
    
    func killSelfAction(sender:UIButton!){
        /*
        mainView!.setDrawImg(currImage, sze:currScale);
        let marg:CGFloat = 5.0;
        let sze = screenSize.width/8;
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.emojiPreview!.alpha = 0.0;
            self.sliderHolder!.frame = CGRectMake(0, self.screenSize.height, self.screenSize.width, self.screenSize.height * 0.5 + 30);
            self.emojiScroller!.frame = CGRectMake(self.screenSize.width - sze + marg*2.0 , self.screenSize.height, CGFloat(sze), self.screenSize.height * 0.5);
            
        })
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.emojiView!.hidden = true;
        }
        */
        mainView!.setDrawImg(currImage, sze:currScale);
        self.emojiView!.hidden = true;
        let marg:CGFloat = 5.0;
        let sze = screenSize.width/8;
        self.emojiPreview!.alpha = 0.0;
        self.sliderHolder!.frame = CGRectMake(0, self.screenSize.height, self.screenSize.width, self.screenSize.height * 0.5 + 30);
        self.emojiScroller!.frame = CGRectMake(self.screenSize.width - sze + marg*2.0 , self.screenSize.height, CGFloat(sze), self.screenSize.height * 0.5);
 
    }
    
    func buttonAction(sender:UIButton!){
        let isInPack:Bool = packs.isInPack( Int(sender.tag) );
        //if not in pack
        if(isInPack == false){
            selectImage(sender);
        }else{
            //if in pack and is purchased
            let isPurchased:Bool = packs.isPackPurchased( Int(sender.tag) );
            if( isPurchased == true) {
                selectImage(sender);
            }else{
                //if not purchased
                let str = packs.checkPack(sender.tag);
                let emojis = packs.getEmojis(str);
                mainView!.initBuy(str, emojis:emojis);
            }
        }
    }
    
    func selectImage(sender:UIButton){
        currImage = "\(sender.tag)";
        emojiPreview!.image = UIImage(named: currImage);
        labelLeft!.image = UIImage(named: currImage)    ;
        labelRight!.image = UIImage(named: currImage);
    }
    
    func sliderValueDidChange(slider: UISlider) {
        currScale = CGFloat( slider.value );
        emojiPreview!.frame = CGRectMake( (screenSize.width * 0.5) - (currScale * 0.5), (screenSize.height * 0.25) - (currScale * 0.5),
            currScale, currScale);
    }
    
    func scrollerActionDrag(sender: UIButton, event:UIEvent) {
        doScroll(sender, event:event);
    }
    
    func scrollerActionUp(sender: UIButton, event:UIEvent) {
        sender.highlighted = false;
    }
    
    func scrollerActionDown(sender: UIButton, event:UIEvent) {
        doScroll(sender, event:event);
    }
    
    func doScroll(sender:UIButton, event:UIEvent){
        sender.highlighted = false;
        //if let touch = touches.first as? UITouch {
        //if let touch = event.touchesForView(sender) as? UITouch {
        
        //var touch = event.touchesForView(sender)!.first! as! UITouch;
        let touch = event.touchesForView(sender)!.first! as UITouch;
            
            let location : CGPoint = touch.locationInView(sender);
            let nrml = location.y / emojiScroller!.bounds.height;
            var yScrollPos:CGFloat = CGFloat( (scrollHeight! - emojiScroller!.bounds.height + btnSze!)  * nrml);
            if(yScrollPos > scrollHeight!){
                yScrollPos = scrollHeight!;
            }
            if(yScrollPos<0.0){
                yScrollPos = 0.0;
            }
            
            emojiHolder!.contentOffset = CGPointMake(0,yScrollPos);
        //}
        //var touch = event.touchesForView(sender)?.anyObject() as UITouch;
        //var previousLocation : CGPoint = touch.previousLocationInView(sender);
        
    }
    
    func showSelf(){
        let marg:CGFloat = 5.0;
        let sze = screenSize.width/8;
        emojiView!.hidden = false;
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.emojiPreview!.alpha = 1.0;
            self.sliderHolder!.frame = CGRectMake(0, self.screenSize.height * 0.5 - 40, self.screenSize.width, self.screenSize.height * 0.5 + 30);
            self.emojiScroller!.frame = CGRectMake(self.screenSize.width - sze + marg*2.0 , self.screenSize.height * 0.5, CGFloat(sze), self.screenSize.height * 0.5);
        })
    }
    
    func resetUserDefault(){
        
        userDefaults.setObject(["100 Pack":false, "Animals Pack":false, "Flags Pack":false, "Fruit Pack":false, "Hearts Pack":false, "Pictures Pack":false, "Sports Pack":false, "Vehicles Pack":false], forKey: "purchases");
        userDefaults.synchronize();
        
    }
    
}
