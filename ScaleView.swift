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
    
    var currImage = "1";
    var currScale:CGFloat = 40.0;
    
    var packs = Packs();
    var userDefaults = NSUserDefaults.standardUserDefaults();
    var mainView = VMainViewController?();
    
    var killButton = UIButton?();
    var emojiPreview = UIImageView?();
    var emojiSlider = UISlider?();
    var palletHolder = UICollectionView?();
    var skinHolder = UICollectionView?();
    var flagHolder = UICollectionView?();
    var labelLeft = UIImageView?();
    var labelRight = UIImageView?();
    var swtch = UISwitch?();
    var optionsHolder = UIView?();
    var skinSelect = SkinSelect?();
    var collectionHolder = UIScrollView?();
    var camButton = UIButton?();

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
        

    }
    
    func setupLayout(){
        
        collectionHolder!.showsHorizontalScrollIndicator = false;
        collectionHolder!.backgroundColor = UIColor.whiteColor();
        collectionHolder!.frame = CGRect(x: 0, y: self.frame.height*0.5, width: self.frame.width, height: self.frame.height*0.5);
        
        
        let collectionFrame = CGRect(x: 0.0, y: 0.0, width: collectionHolder!.frame.width, height: collectionHolder!.frame.height);
        palletHolder!.frame = collectionFrame;
        palletHolder!.frame.size.width = collectionHolder!.frame.width - 70.0;
        
        skinHolder!.frame = collectionFrame;
        skinHolder!.frame.origin.x = collectionHolder!.frame.width;
        flagHolder!.frame = collectionFrame;
        flagHolder!.frame.origin.x = collectionHolder!.frame.width * 2.0;
        
        skinHolder!.backgroundColor = UIColor.whiteColor();
        flagHolder!.backgroundColor = UIColor.whiteColor();
        palletHolder!.backgroundColor = UIColor.whiteColor();
        
        emojiPreview!.frame = CGRectMake( (self.frame.width * 0.5) - (currScale * 0.5), (self.frame.height * 0.25) - (currScale * 0.5),
            currScale, currScale);
        emojiPreview!.image = UIImage(named: "emojis/\(currImage).png");
        
        
        emojiSlider!.minimumValue = 5;
        emojiSlider!.maximumValue = 120;
        emojiSlider!.value = 40;
        
        //button and slider holder
        let y = self.frame.height/2 - 40;
        optionsHolder!.frame = CGRectMake(0.0, y, self.frame.width, 40.0)
        
        
        //switch and label
        swtch!.frame = CGRectMake(5.0, 4.5, 51.0, 31.0);
        
        //images and sliders
        labelLeft!.frame = CGRectMake(5.0, 10.0, 20.0, 20.0);
        labelLeft!.image = UIImage(named: "emojis/\(currImage).png");
        
        //30
        //let slw = slx - 25.0 - 5.0 - 35.0 - 10.0;
        let slw = optionsHolder!.frame.width - 30.0 - 40.0;
        emojiSlider!.frame = CGRectMake(30.0, 4.5, slw, 31.0);
        
        let lrx = optionsHolder!.frame.width - 35.0;
        labelRight!.frame = CGRectMake(lrx, 5.0, 30.0, 30.0);
        labelRight!.image = UIImage(named: "emojis/\(currImage).png");
        
        camButton!.frame = CGRect(x: self.frame.width - 77.0, y: 5.0, width: 72.0, height: 22.0)
        
    }
    
    func initSkinSelect(pnt:CGPoint){//called in viewcontroller.didhighlightitem
        if(skinSelect == nil){
            skinSelect = SkinSelect(pnt: pnt, scl:CGPoint(x: self.frame.width, y: self.frame.height), currEmoji:Int(currImage)!, parent:self);
            //skinSelect!.setNeedsFocusUpdate();
            
            self.addSubview(skinSelect!);
        }
    }
    
    func killSkinSelect(){ // called in buttonAction
        if(skinSelect != nil){
            skinSelect!.removeFromSuperview();
            skinSelect = nil;
        }
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
    
    func setMainController(mvc:VMainViewController){
        mainView = mvc;
    }
    
    func killSelf(){
        
        mainView!.setDrawImg(currImage, sze:currScale);
        self.hidden = true;
        self.emojiPreview!.alpha = 0.0;
 
    }
    
    func buttonAction(index:String){
        killSkinSelect();
        let ind = Int(index)!;
        
        //let isInPack:Bool = packs.isInPack( ind );
        
        selectImage(ind);
        
        //if not in pack
        /*
        if(!isInPack){
        
        }else{
            //if in pack and is purchased
            let isPurchased:Bool = packs.isPackPurchased( ind );
            if( isPurchased == true) {
                selectImage(ind);
            }else{
                //if not purchased
                let str = packs.checkPack(ind);
                let emojis = packs.getEmojis(str);
                mainView!.initBuy(str, emojis:emojis);
            }
        }
        */
    }
    
    func selectImage(index:Int ){
        currImage = "\(index)";
        emojiPreview!.image = UIImage(named: "emojis/\(currImage).png");
        labelLeft!.image = UIImage(named: "emojis/\(currImage).png");
        labelRight!.image = UIImage(named: "emojis/\(currImage).png");
    }
    
    func sliderValueDidChange(val:CGFloat) {
        currScale = val;
        emojiPreview!.frame = CGRectMake( (screenSize.width * 0.5) - (currScale * 0.5), (screenSize.height * 0.25) - (currScale * 0.5),
            currScale, currScale);
    }
    
    func showSelf(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.hidden = false;
            self.emojiPreview!.alpha = 1.0;
        })
    }
    
    func resetUserDefault(){
        
        userDefaults.setObject(["100 Pack":false, "Animals Pack":false, "Flags Pack":false, "Fruit Pack":false, "Hearts Pack":false, "Pictures Pack":false, "Sports Pack":false, "Vehicles Pack":false], forKey: "purchases");
        userDefaults.synchronize();
        
    }
    
   
    
}
