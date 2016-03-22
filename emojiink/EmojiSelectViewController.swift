//
//  EmojiSelectViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/11/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit

@objc protocol EmojiSelectViewControllerDelegate {
    
    optional func emojiDidFinish(emoji:UIImage, size:CGFloat)
    
}

class EmojiSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var ibo_emojiCollectionView:UICollectionView!
    
    var delegate:EmojiSelectViewControllerDelegate!
    var selectedEmoji:UIImage!
    var emojiScale:CGFloat!
    
    
    
    var iapReference = [String:String]()
    

    
    @IBOutlet weak var ibo_emojiSizeSmall:UIImageView!
    @IBOutlet weak var ibo_emojiSizeLarge:UIImageView!
    @IBOutlet weak var ibo_emojiSelected:UIImageView!
    
    //BUTTONS
    @IBOutlet weak var ibo_btn_colors:UIButton!
    @IBOutlet weak var ibo_btn_skin:UIButton!
    @IBOutlet weak var ibo_btn_flags:UIButton!
    
    @IBOutlet weak var ibo_colorSelector:ColorSlider!
    @IBOutlet weak var ibo_skinSelector:SkinSlider!
    
    var emojiDIR = ["/emoji/colors/", "/emoji/skin/0/", "/emoji/flags/"]
    
    var emojis = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCurrentEmoji(selectedEmoji)
        emojiScale = 40
                
        let assets = AssetManager().getAssetsForDir(emojiDIR[0])
        for i in assets {
            emojis.append(AssetManager().getFullAsset(i, dir: emojiDIR[0]))
        }
        
        ibo_btn_colors.selected = true
        
        ibo_colorSelector.cv = ibo_emojiCollectionView;
        ibo_skinSelector.cv = ibo_emojiCollectionView;
        ibo_skinSelector.parent = self;
        
        
        /*LOAD PLIST INTO DICTIONARY*/
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("iap_list_colors", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            self.iapReference = dict as! [String : String]
        }
        
        
//        var productIden = Set<String>()
//        productIden.insert("com.99centbrains.blabberlab.labrarian")
        
        var productIden = Set<String>()
        productIden.insert("com.tight.emojiink.all")
        productIden.insert("com.tight.emojiink.hearts")
        productIden.insert("com.tight.emojiink.sports")
        productIden.insert("com.tight.emojiink.vegan")
        productIden.insert("com.tight.emojiink.vehicles")
        
        
        let iap = SwiftInAppPurchase.sharedInstance
        
        iap.requestProducts(productIden) { (products, invalidIdentifiers, error) -> () in
            print(error)
        }
        
        /*LOAD IAP IDS and REQUEST*/
  
        
    }
    
    override func viewDidLayoutSubviews() {
   
        super.viewDidLayoutSubviews()
    
        
        let flowLayoutFull = UICollectionViewFlowLayout()
        flowLayoutFull.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
//        flowLayoutFull.itemSize = CGSizeMake(
//            ibo_emojiCollectionView.frame.size.width/5 - 20,
//            ibo_emojiCollectionView.frame.size.width/5 - 20)
        flowLayoutFull.scrollDirection = .Vertical
        flowLayoutFull.minimumLineSpacing = 0
        
        //print(ibo_emojiCollectionView.frame)
        
        ibo_emojiCollectionView.setCollectionViewLayout(flowLayoutFull, animated: false)
        //ibo_emojiCollectionView.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
    
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(collectionView.bounds.size.width/7 - 10,
                collectionView.bounds.size.width/7 - 10)
    }
    
    @IBAction func iba_toggleEmojiType(btn:UIButton){
        
        ibo_btn_colors.selected = false
        ibo_btn_skin.selected = false
        ibo_btn_flags.selected = false

        btn.selected = true
        
        
        switch btn.tag {
            
            case 0:
                
                ibo_btn_colors.selected = true
                self.resizeCollectionView(ibo_skinSelector.frame.size.width)
                ibo_colorSelector.hidden = false
                ibo_skinSelector.hidden = true
            
            case 1:
                
                ibo_btn_skin.selected = true
                self.resizeCollectionView(ibo_skinSelector.frame.size.width)
                ibo_colorSelector.hidden = true
                ibo_skinSelector.hidden = false
            
            case 2:
                
                ibo_btn_flags.selected = true
                self.resizeCollectionView(0)
            
                ibo_colorSelector.hidden = true
                ibo_skinSelector.hidden = true
            
            default:
                print("Some Default Stuffffs")
            
            
        }
        

        emojis = []
        ibo_emojiCollectionView.reloadData()
        
        
        var someArray = [String]()
        let assets = AssetManager().getAssetsForDir(emojiDIR[btn.tag])
        for i in assets {
            someArray.append(AssetManager().getFullAsset(i, dir: emojiDIR[btn.tag]))
        }
        emojis = someArray
        ibo_emojiCollectionView.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
        ibo_emojiCollectionView.reloadSections(NSIndexSet(index: 0))
        
        
        //print(emojis.count)
        
    }
    
    func resizeCollectionView(i:CGFloat){
        
        ibo_emojiCollectionView.frame = CGRectMake(
            ibo_emojiCollectionView.frame.origin.x,
            ibo_emojiCollectionView.frame.origin.x,
            self.view.frame.size.width - i,
            ibo_emojiCollectionView.frame.size.height)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EmojiSelectCollectionViewCell
        cell.ibo_imageView.image = nil
        cell.locked = false
        let cellName = self.prettyName(emojis[indexPath.item])
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("com.tight.emojiink.all"){
            
            if let iapKey = self.isLocked(cellName){
                cell.iapKey = iapKey
                cell.locked = !self.boolForKey(iapKey)
            }

            
        }
        
        
        cell.setupImage(emojis[indexPath.item])
        return cell
    
    }
    
    func boolForKey(key:String) -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }

    func prettyName(name:String) -> String{
        //CLEANS UP NAME file Name to NAME of PNG
        var key = name.stringByReplacingOccurrencesOfString(AssetManager().ResourcePath(), withString: "")
        
        for dir in emojiDIR {
            key = key.stringByReplacingOccurrencesOfString(dir, withString: "")
        }
        
        key = key.stringByReplacingOccurrencesOfString(".png", withString: "")
        
        return key

    }
    
    //CHECKS IF FILE HAS AN IAP ID
    func isLocked(name:String) -> String? {
        
        if let value = self.iapReference[self.prettyName(name)]{
            
            return value
        }
        
        
        return nil
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //SLECT IMAGE
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EmojiSelectCollectionViewCell
        let image = cell.ibo_imageView.image
        
        if cell.locked == false {
            self.setCurrentEmoji(image!)
        } else {
            self.promptLocked(cell.iapKey)
        }
        
    }
    
    func setCurrentEmoji(img:UIImage){
        
        selectedEmoji = img
        
        if selectedEmoji != nil {
            
            ibo_emojiSizeSmall.image = selectedEmoji
            ibo_emojiSizeLarge.image = selectedEmoji
            ibo_emojiSelected.image = selectedEmoji
            
        }
        
    }
    
    func promptLocked(id:String){
        
        print(id)

        let alert = UIAlertController(
            title: self.getIAPrompt(id)[0],
            message: self.getIAPrompt(id)[1], preferredStyle: .Alert);
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil);
            //BEGIN UNLOCK
            self.unlockEmoji(id)
        }
        let noAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        let allAction = UIAlertAction(title: "Unlock all 7 Packs", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.unlockAll()
        }
        
        let restore = UIAlertAction(title: "Restore Purchases", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.restorePurchases()
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("com.tight.emojiink.all"){
            alert.addAction(allAction)
        }
        
        alert.addAction(restore)
        
        self.presentViewController(alert, animated: true, completion: nil);
 
        
    }
    
    func getIAPrompt(id:String) -> [String]{
        
        switch id {
            
        case "com.tight.emojiink.animals":
            return ["Buy the Animals Pack", "99¢ for 🐱,🐯,🐖,🐦,🐤,🐶,🙊, and 🐒"]
            
        case "com.tight.emojiink.hearts":
            return ["Buy the Hearts Pack", "99¢ for ❤️,💔,💗,💛,❣,💖,💚,💕,💘,💙,💞,💝,💜,💓,💟,and ♥️"]
            
        case "com.tight.emojiink.sports":
            return ["Buy the Sports Pack", "99¢ for ⚽️🏐🏓,🎿,🎣,⛹,🏀,🏉🏸,⛷,🚣🏋,🏈,🎱🏒,🏂,🏊,🚴,⚾️,⛳️🏑,⛸,🏄🏿,🚵🏾,🎾🏌🏏🏹,🏇🏾,🎳,🎯,and 🎲"]
            
        case "com.tight.emojiink.vegan":
            return ["Buy the Vegan Pack", "99¢ for 🍏,🍌,🍒🌶,🍎,🍉,🍑,🌽,🍐,🍇,🍍,🍠,🍊,🍓,🍅,🍋,🍈,🍆,and 🍄"]
            
        case "com.tight.emojiink.vehicles":
            return ["Buy the Vehicles Pack", "99¢ for 🚗,🚓,🚚,🚡,🚝,🚂,🚁,🚕,🚓,🚛,🚔,🚠,🚄,🚆,🛩,🚙,🚑,🚜,🚍,🚟,🚅,🚇,✈️,🚌,🚒🏍,🚘,🚃,🚈,🚊,🛫,🚎,🚐,🚲,🚖,🚋,🚞,🚉,🛬,⛵️,🚀,🛥,🛰,🚤,⛴,and 🛳"]
            
        default:
            return ["Unlock Packs", "Want to unlock some Stuff"]
        }
        
        
    }
    
    
    func unlockEmoji(id:String){
        
        
        
        let iap = SwiftInAppPurchase.sharedInstance
        iap.addPayment(id, userIdentifier: nil) { (result) -> () in
            
            switch result{
            case .Purchased(let productId,let transaction,let paymentQueue):
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: productId)
                paymentQueue.finishTransaction(transaction)
                self.ibo_emojiCollectionView.reloadData()
            case .Failed(let error):
                self.showError(error.localizedDescription)
            default:
                break
            }
        }
        
//        IAPManager.sharedManager.purchaseProductWithId(id) { (error) -> Void in
//            if error == nil {
//                // successful purchase!
//                //SHOW SUCCESS
//                self.ibo_emojiCollectionView.reloadData()
//                
//            } else {
//                // something wrong..
//                //ALERT ERROR
//            }
//        }
    
        
    }
    
    func unlockAll(){
        
        self.unlockEmoji("com.tight.emojiink.all")
    
    }
    
    func restorePurchases(){
        
        let iap = SwiftInAppPurchase.sharedInstance
        iap.restoreTransaction(nil) { (result) -> () in
            switch result{
            case .Restored(let productId,let transaction,let paymentQueue) :
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: productId)
                paymentQueue.finishTransaction(transaction)
                self.ibo_emojiCollectionView.reloadData()
                
                
                let alert = UIAlertView(title: "Restored", message: "Purchases have been restored!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles:"Ok")
                alert.show()
                
            case .Failed(let error):
                print(error)
                self.showError(error.localizedDescription)
                
            default:
                break
            }
        }
    
    }
    
    func showError(string:String){
        
        let alert = UIAlertView(title: "Oops", message: string, delegate: nil, cancelButtonTitle: nil, otherButtonTitles:"Ok")
        alert.show()
    }
    
    
    @IBAction func iba_dismissVC(){
        print("dismiss = \(delegate)");
        delegate.emojiDidFinish!(selectedEmoji, size:emojiScale)
    
    }
    
    @IBAction func iba_scaleEmoji(slider:UISlider){
        
        let scale = slider.value
        //print(scale)
        emojiScale = 40 * CGFloat(scale)
        ibo_emojiSelected.transform = CGAffineTransformMakeScale(CGFloat(scale), CGFloat(scale))
        
    }
    
    
}





class EmojiSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ibo_imageView:UIImageView!
    var cellImage:UIImage!
    
    var locked:Bool = false
    var iapKey:String!
    var name:String!
    
    func setupImage(file:String){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let imageData = NSData(contentsOfFile: file )
            
            if let data = imageData {
                self.cellImage = UIImage(data:data)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if self.locked == true {
                    self.ibo_imageView.alpha = 0.4
                } else {
                    self.ibo_imageView.alpha = 1
                }
                
                self.ibo_imageView.image = self.cellImage
                
            }
            
        }
        
    }
    
}


//EMPTY ARRAY EXTENTION
extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
