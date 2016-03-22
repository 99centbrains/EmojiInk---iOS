//
//  MainViewController.swift
//  Emoji.inkTest
//
//  Created by Vince McKelvie on 2/14/15.
//  Copyright (c) 2015 BetterMagic. All rights reserved.
//

import UIKit
import StoreKit

class VMainViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//class MainViewController: UIViewController{
    
    var currImage = "0";
    var viewClass = DrawView?();
    //var scaleClass = ScaleView?();
    
    //"com.awesomeguys.emojiink.100",
    //"com.awesomeguys.emojiink.animals",
    //"com.awesomeguys.emojiink.flags",
    //"com.awesomeguys.emojiink.fruits",
    //"com.awesomeguys.emojiink.hearts",
    //"com.awesomeguys.emojiink.pictures",
    //"com.awesomeguys.emojiink.sport",
    //"com.awesomeguys.emojiink.vehicles",
    //s"com.awesomeguys.emojiink.all"
    var comPacks:[String:String] = [
        "com.tight.emojiink.100":"100 Pack",
        "com.tight.emojiink.animals":"Animals Pack",
        "com.tight.emojiink.flags":"Flags Pack",
        "com.tight.emojiink.fruits":"Fruit Pack",
        "com.tight.emojiink.hearts":"Hearts Pack",
        "com.tight.emojiink.pictures":"Pictures Pack",
        "com.tight.emojiink.sport":"Sports Pack",
        "com.tight.emojiink.vehicles":"Vehicles Pack",
        "com.tight.emojiink.all":"all"
    ];
    
    var p = SKProduct();
    var list = [SKProduct]();
    var cellSize:CGSize?;
    var emojis = [String]();
    var last = [String]();
    
    @IBOutlet weak var pickerButton: UIButton!
    @IBAction func pickerInit(sender: AnyObject) {
        viewClass!.canDraw = false;
        scaleClass!.showSelf();
        redoButton.hidden = true;
        undoButton.hidden = true;
        exportButton.hidden = true;
    }
    
    @IBAction func composeAction(sender: AnyObject) {
        let alert = UIAlertController(title: "💣💣💣💣💣💣💣", message: "Are you 💯 you want to start all over?", preferredStyle: .Alert);
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.viewClass!.destroyImage();
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        alert.addAction(yesAction);
        alert.addAction(noAction);
        
        self.presentViewController(alert, animated: true, completion: nil);
        
    }

    @IBOutlet weak var scaleClass: ScaleView!
    
    @IBAction func tshirtAction(sender: AnyObject) {

        let obj = self.viewClass!.getImage();
        
        //for let controller
        //let arr:NSArray = [obj];

        let img = UIImage(data: obj);
        let yoshirtRefURL:String = "yoshirt://design?pb=1&yscid=AppHook&referring_app=emojiink&rid=tight";
        
        UIPasteboard.generalPasteboard().image = img
        let yoshirtURL = NSURL(string: yoshirtRefURL)
        UIApplication.sharedApplication().openURL(yoshirtURL!)
        
        UIApplication.sharedApplication().openURL(NSURL(string: "Yoshirt://")!);
        
        //let controller = UIActivityViewController(activityItems: arr as [AnyObject], applicationActivities: nil);
        
        // self.presentViewController(controller, animated: true, completion: nil);
        
    }
    
    @IBAction func exportAction(sender: AnyObject) {
        
        let obj = self.viewClass!.getImage();
        
        //for let controller
        let arr:NSArray = [obj];
        
        let controller = UIActivityViewController(activityItems: arr as [AnyObject], applicationActivities: nil);
        
         self.presentViewController(controller, animated: true, completion: nil);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        viewClass = self.view as? DrawView;
        
        scaleClass.setMainController(self);
        self.setScaleVars();
        scaleClass.setupLayout();
        
        //for(var i = 1; i<1611; i++){
        for(var i = 1; i<=1601; i++){
            emojis.append("emojis/\(i).png");
        }
        for(var k = 1602; k<=1611; k++){
            last.append("emojis/\(k).png");
        }
        
        //in app
        SKPaymentQueue.defaultQueue().addTransactionObserver(self);
        self.getProductInfo();
        
        setupLayout();
        //disable buttons
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func setDrawImg(img:String, sze:CGFloat){
        //viewClass!.setDrawImg(img, sze:sze);
        viewClass!.canDraw = true;
        pickerButton.setImage(UIImage(named: "emojis/\(img).png"), forState: .Normal);
    }
    
    
    //in app
    
    
    func initBuy(str:String, emojis:String){
        var costString:String = "¢99";
        
        if(str == "100 Pack"){
            costString = "$99";
        }
        
        let alert = UIAlertController(title: "Buy the \(str)", message: "\(costString) for \(emojis)", preferredStyle: .Alert);
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //self.scaleClass!.unlockProduct(str);
            self.parseProduct(str);
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        let allAction = UIAlertAction(title: "Unlock all 7 Packs for $4.99 ", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //self.scaleClass!.unlockProduct("all");
            self.parseProduct("all");
        }
        
        let restoreAction = UIAlertAction(title: "Restore In App Purchaces", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.restorePurchases();
            //self.scaleClass!.unlockProduct(str);
            //self.parseProduct(str);
        }
        
        alert.addAction(yesAction);
        alert.addAction(cancelAction);
        alert.addAction(restoreAction);
        
        if(str != "100 Pack"){
            alert.addAction(allAction)
        }
        
        self.presentViewController(alert, animated: true, completion: nil);
        
    }
    
    func restorePurchases(){
        SKPaymentQueue.defaultQueue().addTransactionObserver(self);
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions();
    }
   
    
    func getProductInfo(){
        
        if (SKPaymentQueue.canMakePayments()){
            //var str = [String]();
            
            //for (pack, numbers) in comPacks {
                //str.append(pack);
            //}
            
            //print("get product info");
            
            let productID:NSSet = NSSet(objects:
                "com.tight.emojiink.100",
                "com.tight.emojiink.animals",
                "com.tight.emojiink.flags",
                "com.tight.emojiink.fruits",
                "com.tight.emojiink.hearts",
                "com.tight.emojiink.pictures",
                "com.tight.emojiink.sport",
                "com.tight.emojiink.vehicles",
                "com.tight.emojiink.all"
            );

            //let productID:NSSet = NSSet(objects:str);
            
            //let request:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            let request:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self;
            request.start();
        }

    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse){
        
        let products = response.products;
        
        print("products count = \(products.count)");
        
        for product in products{
            list.append(product );
        }
        print("append to list");
        print("list after append = \(list.count)");
        
        //re enable buttons
        //
    }
    
    func parseProduct(str:String){
        print("str = \(str)");
        print("list length = \(list.count)");
        for product in list{
            
            let prodID = product.productIdentifier;
            //println("prodID = \(prodID)");
            
            if(comPacks[prodID] == str){
                p = product;
                print("product = \(p)");
                buyProduct();
                break;
            }
        }
    }
    
    func buyProduct() {
        let pay = SKPayment(product: p);
        SKPaymentQueue.defaultQueue().addTransactionObserver(self);
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment);
    }
    
    
    func handlePurchase(str:String){
        let packString:String = comPacks[str]!;
        self.scaleClass!.unlockProduct(packString);
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                    case .Purchased:
                        self.handlePurchase(p.productIdentifier as String);
                        SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                        break;
                    case .Failed:
                        SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                        break;
                    case .Restored:
                        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                        break
                    default:
                        break;
                }
            }
        }
    }
    
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    func setupLayout(){
        redoButton.frame = CGRect(x: 5.0, y: 5.0, width: 55.0, height: 40.0);
        undoButton.frame = CGRect(x: 65.0, y: 5.0, width: 55.0, height: 40.0);
        exportButton.frame = CGRect(x: self.view.frame.width - 165.0, y: 5.0, width: 60.0, height: 30.0);
    }
    
    @IBOutlet weak var sclBgButton: UIButton!
    @IBAction func sclBgButtonPress(sender: AnyObject) {
        scaleClass.killSelf();
        redoButton.hidden = false;
        undoButton.hidden = false;
        exportButton.hidden = false;

    }
    
    @IBOutlet weak var flagCollection: UICollectionView!
    @IBOutlet weak var palletCollection: UICollectionView!
    @IBOutlet weak var skinCollection: UICollectionView!
    @IBOutlet weak var sclSwitch: UISwitch!
    @IBOutlet weak var sclImgLabelRight: UIImageView!
    @IBOutlet weak var sclSlider: UISlider!
    @IBOutlet weak var sclImgLabelLeft: UIImageView!
    @IBOutlet weak var sclImgMain: UIImageView!
    @IBOutlet weak var sclButtonsHolder: UIView!
    @IBOutlet weak var collectionHolder: UIScrollView!
    @IBOutlet weak var sclCamera: UIButton!
    
    @IBAction func cameraAction(sender: AnyObject) {
        
    }
    
    @IBAction func sclSliderAction(sender: AnyObject) {
        scaleClass.sliderValueDidChange( CGFloat(sclSlider.value) );
    }
    
    @IBAction func sclSwitchAction(sender: AnyObject) {
        viewClass!.isTouch = sclSwitch.on;
    }
    
    @IBAction func undoAction(sender: AnyObject) {
        viewClass!.undo();
    }
    
    @IBAction func redoAction(sender: AnyObject) {
        viewClass!.redo()
    }
    
    func setScaleVars(){
        
        sclCamera.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.camButton = sclCamera;
        
        scaleClass.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height);
        sclBgButton.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.killButton = sclBgButton;
        sclSwitch.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.swtch = sclSwitch;
        sclImgLabelLeft.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.labelLeft = sclImgLabelLeft;
        sclImgLabelRight.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.labelRight = sclImgLabelRight;
        
        collectionHolder.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.collectionHolder = collectionHolder;
        
        palletCollection.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.palletHolder = palletCollection;
        skinCollection.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.skinHolder = skinCollection;
        flagCollection.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.flagHolder = flagCollection;
        
        
        sclSlider.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.emojiSlider = sclSlider;
        sclImgMain.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.emojiPreview = sclImgMain;
        sclButtonsHolder.translatesAutoresizingMaskIntoConstraints = true;
        scaleClass.optionsHolder = sclButtonsHolder;
    }
    
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(1, 1, 1, 1);
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        cellSize = CGSizeMake((self.view.frame.width/10) - (1), (self.view.frame.width/10) - (1));
        return cellSize!;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if(collectionView == palletCollection){
            
            let pallet:PalletCollection = collectionView.dequeueReusableCellWithReuseIdentifier("Pallet", forIndexPath: indexPath) as! PalletCollection;
            let img = UIImage(named: emojis[indexPath.row]);
            pallet.img.image = img;
            return pallet;
            
        }else if(collectionView == skinCollection){
            
            let skin:SkinCollection = collectionView.dequeueReusableCellWithReuseIdentifier("Skin", forIndexPath: indexPath) as! SkinCollection;
            let img = UIImage(named: emojis[indexPath.row]);
            skin.img.image = img;
            return skin;
            
        }
        
        let flag:FlagCollection = collectionView.dequeueReusableCellWithReuseIdentifier("Flag", forIndexPath: indexPath) as! FlagCollection;
        let img = UIImage(named: emojis[indexPath.row]);
        flag.img.image = img;
        return flag;
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(collectionView == palletCollection){
            scaleClass.buttonAction("\(indexPath.row+1)")
        }else if(collectionView == skinCollection){
            scaleClass.buttonAction("\(indexPath.row+1)")
        }else if(collectionView == flagCollection){
            scaleClass.buttonAction("\(indexPath.row+1)")
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let attr = collectionView.layoutAttributesForItemAtIndexPath(indexPath);
        let fr = attr!.frame;
        let sup = collectionView.convertRect(fr, toView: self.view);
        
        scaleClass.initSkinSelect(sup.origin);
        
        print("SUPORIGIN = \(sup.origin)");
        
        //sclCollection.scrollEnabled = false;
        
    }
    
    //func collection
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0);
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

