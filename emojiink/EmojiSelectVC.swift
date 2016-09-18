//
//  EmojiSelectViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/11/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit

class EmojiSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var ibo_emojiCollectionView:UICollectionView!
    @IBOutlet weak var ibo_scaleSlider:UISlider!
    
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
        
        ibo_btn_colors.isSelected = true
        
        ibo_colorSelector.cv = ibo_emojiCollectionView;
        ibo_skinSelector.cv = ibo_emojiCollectionView;
        ibo_skinSelector.parent = self;
        
        
        /*LOAD PLIST INTO DICTIONARY*/
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "iap_list_colors", ofType: "plist") {
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
        flowLayoutFull.scrollDirection = .vertical
        flowLayoutFull.minimumLineSpacing = 0
        
        //print(ibo_emojiCollectionView.frame)
        
        ibo_emojiCollectionView.setCollectionViewLayout(flowLayoutFull, animated: false)
        //ibo_emojiCollectionView.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/7 - 10,
                      height: collectionView.bounds.size.width/7 - 10)
    }
    
    @IBAction func iba_toggleEmojiType(_ btn:UIButton){
        
        ibo_btn_colors.isSelected = false
        ibo_btn_skin.isSelected = false
        ibo_btn_flags.isSelected = false
        
        btn.isSelected = true
        
        
        switch btn.tag {
            
        case 0:
            
            ibo_btn_colors.isSelected = true
            self.resizeCollectionView(ibo_skinSelector.frame.size.width)
            ibo_colorSelector.isHidden = false
            ibo_skinSelector.isHidden = true
            
        case 1:
            
            ibo_btn_skin.isSelected = true
            self.resizeCollectionView(ibo_skinSelector.frame.size.width)
            ibo_colorSelector.isHidden = true
            ibo_skinSelector.isHidden = false
            
        case 2:
            
            ibo_btn_flags.isSelected = true
            self.resizeCollectionView(0)
            
            ibo_colorSelector.isHidden = true
            ibo_skinSelector.isHidden = true
            
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
        ibo_emojiCollectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 10, height: 10), animated: false)
        ibo_emojiCollectionView.reloadSections(IndexSet(integer: 0))
        
        
        //print(emojis.count)
        
    }
    
    func resizeCollectionView(_ i:CGFloat){
        
        ibo_emojiCollectionView.frame = CGRect(
            x: ibo_emojiCollectionView.frame.origin.x,
            y: ibo_emojiCollectionView.frame.origin.x,
            width: self.view.frame.size.width - i,
            height: ibo_emojiCollectionView.frame.size.height)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiSelectCollectionViewCell
        cell.ibo_imageView.image = nil
        cell.locked = false
        let cellName = self.prettyName(emojis[(indexPath as NSIndexPath).item])
        
        if !UserDefaults.standard.bool(forKey: "com.tight.emojiink.all"){
            
            if let iapKey = self.isLocked(cellName){
                cell.iapKey = iapKey
                cell.locked = !self.boolForKey(iapKey)
            }
            
            
        }
        
        
        cell.setupImage(emojis[(indexPath as NSIndexPath).item])
        return cell
        
    }
    
    func boolForKey(_ key:String) -> Bool{
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func prettyName(_ name:String) -> String{
        //CLEANS UP NAME file Name to NAME of PNG
        var key = name.replacingOccurrences(of: AssetManager().ResourcePath(), with: "")
        
        for dir in emojiDIR {
            key = key.replacingOccurrences(of: dir, with: "")
        }
        
        key = key.replacingOccurrences(of: ".png", with: "")
        
        return key
        
    }
    
    //CHECKS IF FILE HAS AN IAP ID
    func isLocked(_ name:String) -> String? {
        
        if let value = self.iapReference[self.prettyName(name)]{
            
            return value
        }
        
        
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //SLECT IMAGE
        
        let cell = collectionView.cellForItem(at: indexPath) as! EmojiSelectCollectionViewCell
        let image = cell.ibo_imageView.image
        
        if cell.locked == false {
            self.setCurrentEmoji(image!)
        } else {
            self.promptLocked(cell.iapKey)
        }
        
    }
    
    func setCurrentEmoji(_ img:UIImage){
        
        selectedEmoji = img
        
        if selectedEmoji != nil {
            
            ibo_emojiSizeSmall.image = selectedEmoji
            ibo_emojiSizeLarge.image = selectedEmoji
            ibo_emojiSelected.image = selectedEmoji
            
        }
        
    }
    
    func promptLocked(_ id:String){
        
        print(id)
        
        let alert = UIAlertController(
            title: self.getIAPrompt(id)[0],
            message: self.getIAPrompt(id)[1], preferredStyle: .alert);
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil);
            //BEGIN UNLOCK
            self.unlockEmoji(id)
        }
        let noAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil);
        }
        let allAction = UIAlertAction(title: "Unlock all 7 Packs", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.unlockAll()
        }
        
        let restore = UIAlertAction(title: "Restore Purchases", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.restorePurchases()
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        if !UserDefaults.standard.bool(forKey: "com.tight.emojiink.all"){
            alert.addAction(allAction)
        }
        
        alert.addAction(restore)
        
        self.present(alert, animated: true, completion: nil);
        
        
    }
    
    func getIAPrompt(_ id:String) -> [String]{
        
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
    
    
    func unlockEmoji(_ id:String){
        
        
        
        let iap = SwiftInAppPurchase.sharedInstance
        iap.addPayment(id, userIdentifier: nil) { (result) -> () in
            
            switch result{
            case .purchased(let productId,let transaction,let paymentQueue):
                
                UserDefaults.standard.set(true, forKey: productId)
                paymentQueue.finishTransaction(transaction)
                self.ibo_emojiCollectionView.reloadData()
            case .failed(let error):
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
            case .restored(let productId,let transaction,let paymentQueue) :
                UserDefaults.standard.set(true, forKey: productId)
                paymentQueue.finishTransaction(transaction)
                self.ibo_emojiCollectionView.reloadData()
                
                
                let alert = UIAlertView(title: "Restored", message: "Purchases have been restored!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles:"Ok")
                alert.show()
                
            case .failed(let error):
                print(error)
                self.showError(error.localizedDescription)
                
            default:
                break
            }
        }
        
    }
    
    func showError(_ string:String){
        
        let alert = UIAlertView(title: "Oops", message: string, delegate: nil, cancelButtonTitle: nil, otherButtonTitles:"Ok")
        alert.show()
    }
    
    
    @IBAction func iba_dismissVC(){
        print("dismiss = \(delegate)");
        delegate.emojiDidFinish!(selectedEmoji, size:emojiScale)
        
    }
    
    @IBAction func iba_slideScaleEmoji(slider:UISlider){
        
        let scale = slider.value
        //print(scale)
        emojiScale = 40 * CGFloat(scale)
        ibo_emojiSelected.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        
    }
    
    
}





class EmojiSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ibo_imageView:UIImageView!
    var cellImage:UIImage!
    
    var locked:Bool = false
    var iapKey:String!
    var name:String!
    
    func setupImage(_ file:String){
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let imageData = try? Data(contentsOf: URL(fileURLWithPath: file) )
            
            if let data = imageData {
                self.cellImage = UIImage(data:data)
            }
            
            DispatchQueue.main.async {
                
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

@objc protocol EmojiSelectViewControllerDelegate {
    
    @objc optional func emojiDidFinish(_ emoji:UIImage, size:CGFloat)
    
}

//EMPTY ARRAY EXTENTION
extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
