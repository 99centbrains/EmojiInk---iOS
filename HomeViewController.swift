//
//  HomeViewController.swift
//  emoji.ink
//
//  Created by Franky Aguilar on 1/11/16.
//  Copyright © 2016 tight corp. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, EmojiSelectViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoEditViewControllerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var ibo_drawView:DrawView!
    @IBOutlet var vc_emojiSelect:EmojiSelectViewController!
    
    @IBOutlet weak var ibo_emojiButton:UIButton!
    
    var currentEmoji:UIImage!
    
    var importedPhoto:UIImageView!
    
    var vc_photoEditor:PhotoEditViewController!
    var vc_emojiScaleVC:EmojiScaleViewController!
    
    var longTapGesture:UILongPressGestureRecognizer!
    
    var panGesture:UIPanGestureRecognizer!
    var pinchGesture:UIPinchGestureRecognizer!
    
    @IBOutlet weak var ibo_renderView:UIView!
    
    @IBOutlet weak var ibo_bottomPhotoEdit:UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ibo_bottomPhotoEdit.hidden = true
        
        //GESTURES FOR PHOTO IMPORT
        panGesture = UIPanGestureRecognizer(target: self, action: "stickyMove:")
        pinchGesture = UIPinchGestureRecognizer(target: self, action: "stickyPinch:")
        
        panGesture.delegate = self
        pinchGesture.delegate = self
        
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        
        longTapGesture = UILongPressGestureRecognizer(target: self, action: "longTap:")
        longTapGesture.delegate = self
        longTapGesture.minimumPressDuration = 1.0
        ibo_emojiButton.addGestureRecognizer(longTapGesture)
        
        
        ibo_renderView.userInteractionEnabled = true
        
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        currentEmoji = UIImage(named: "emoji_start")
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ibo_drawView.isActive == false {
        
            ibo_drawView.setUp()
            ibo_drawView.currImage = currentEmoji.CGImage
            ibo_emojiButton.setImage(UIImage(CGImage: ibo_drawView.currImage!), forState: .Normal)
        
        }
        
        //handleEmojiPress();
    }
    
    @IBAction func iba_clearCanvas(){
        
        let alert = UIAlertController(title: "💣💣💣💣💣💣💣", message: "Are you 💯 you want to start all over?", preferredStyle: .Alert);
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.ibo_drawView.destroyImage()
            self.photoTrash()
            
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        alert.addAction(yesAction);
        alert.addAction(noAction);
        
        self.presentViewController(alert, animated: true, completion: nil);
    
    }
    
    @IBAction func iba_showEmojiSelectScreen(){
        
        /*
        if vc_emojiSelect == nil {
        
            vc_emojiSelect = self.storyboard?.instantiateViewControllerWithIdentifier("sb_EmojiSelectViewController") as! EmojiSelectViewController
            vc_emojiSelect.selectedEmoji = UIImage(CGImage: ibo_drawView.currImage!)
            vc_emojiSelect.delegate = self
            
        }
        
        self.view.addSubview(vc_emojiSelect.view)
        
        removeGesters()
        */
        
        handleEmojiPress();
    }
    
    func handleEmojiPress(){
        
        if vc_emojiSelect == nil {
            
            vc_emojiSelect = self.storyboard?.instantiateViewControllerWithIdentifier("sb_EmojiSelectViewController") as! EmojiSelectViewController
            vc_emojiSelect.selectedEmoji = UIImage(CGImage: ibo_drawView.currImage!)
            vc_emojiSelect.delegate = self
            
        }
        
        self.view.addSubview(vc_emojiSelect.view)
        
        removeGesters()

    }
    
    func emojiDidFinish(emoji:UIImage, size:CGFloat){
        
        print("did finish");
        
        vc_emojiSelect.view.removeFromSuperview()
        
        currentEmoji = emoji
        
        ibo_emojiButton.setImage(emoji, forState: .Normal)
        ibo_drawView.currImage = currentEmoji.CGImage
        ibo_drawView.currSize = size
        
        
    }
    
    /*
    CANVAS EDITS
    */
    @IBAction func iba_canvasUNDO(){
        
        ibo_drawView.undo()
        
    }
    
    @IBAction func iba_canvasREDO(){
        
        ibo_drawView.redo()
        
    }
    
    @IBAction func iba_canvasSAVE(sender:UIBarButtonItem){
        
        
        renderImage { (image:UIImage) -> () in
            
            
            var items = [AnyObject]()
            let activities = [UIActivity]()
            
            items.append(image)
            items.append("#EmojiInk")
            
            
            let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
            controller.popoverPresentationController?.sourceView = self.view
            
            controller.completionWithItemsHandler = { (type: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) -> Void in
                print("Type = \(type)")
                print("Completed = \(completed)")
                print("ReturnedItems = \(returnedItems)")
                print("Error = \(error)")
            }
            
            self.presentViewController(controller, animated: true, completion: nil)
            
            
        }
        
    }
    
    //SAVE IMAGE
    func renderImage(callback: (UIImage) -> ()) {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            if self.importedPhoto != nil {
            if self.importedPhoto.alpha < 1  {
                self.importedPhoto.hidden = true
            }
            }
            
            
            
            UIGraphicsBeginImageContextWithOptions(self.ibo_drawView.frame.size, false, 0.0)
            self.ibo_drawView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let drawRender = UIImageView(image: drawImage)
            drawRender.frame = CGRectMake(0, 0, self.ibo_drawView.frame.size.width, self.ibo_drawView.frame.size.height)
            
            self.ibo_renderView.addSubview(drawRender)
            
            
            UIGraphicsBeginImageContextWithOptions(self.ibo_renderView.frame.size, false, 0.0)
            self.ibo_renderView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            drawRender.removeFromSuperview()
            callback(image)
            
            
            
            if self.importedPhoto != nil {
                self.importedPhoto.hidden = false
            }
//
        }
        
    }
    
    /*
    PHOTO TOOLS
    */
    @IBAction func iba_photoImport(){
        
        if importedPhoto != nil {
            
            let actionSheetController: UIAlertController = UIAlertController(
                title: "Photo Options",
                message: nil,
                preferredStyle: .ActionSheet)
            
            let picker = UIImagePickerController()
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Edit", style: .Default)
                { action -> Void in
                    self.showPhotoEdit()
            }
            
            actionSheetController.addAction(takePictureAction)
            //Create and add a second option action
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Delete Image", style: .Default)
                { action -> Void in
                    self.photoTrash()
            }
            
            actionSheetController.addAction(choosePictureAction)
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = self.view
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)

            return
        
        }
        
        let actionSheetController: UIAlertController = UIAlertController(
            title: "Import Photo",
            message: nil,
            preferredStyle: .ActionSheet)
        
        let picker = UIImagePickerController()
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
            { action -> Void in
                
                picker.delegate = self
                picker.sourceType = .PhotoLibrary
                self.presentViewController(picker, animated: true, completion: nil)
                
                
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take A Picture", style: .Default)
            { action -> Void in
                
                picker.delegate = self
                picker.sourceType = .Camera
                self.presentViewController(picker, animated: true, completion: nil)
                
                
        }
        actionSheetController.addAction(takePictureAction)
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = self.view
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        picker.dismissViewControllerAnimated(true) { () -> Void in
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            self.importedPhoto = UIImageView(frame: self.ibo_drawView.frame)
            self.importedPhoto.contentMode = .ScaleAspectFill
            self.importedPhoto.image = image
            self.importedPhoto.userInteractionEnabled = false
            self.ibo_renderView.insertSubview(self.importedPhoto, belowSubview: self.ibo_drawView)
            
            self.showPhotoEdit()
            

        }
    
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func photoTrash(){
        
        self.hidePhotoEdit()
        self.importedPhoto.removeFromSuperview()
        self.importedPhoto = nil
        self.ibo_drawView.userInteractionEnabled = true
        
        removeGesters()
        
    }
    
    func photoOverlayToggle(toggle:Bool){
        
        
        if toggle == true {
            
            self.importedPhoto.alpha = 1.0

        } else {
            
            self.importedPhoto.alpha = 0.5
            
        }
        
        self.view.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
    
    }
    
    func photoMoveScale(toggle:Bool){
        
        
    
    }
    
    func removeGesters(){
        
        self.ibo_renderView.removeGestureRecognizer(panGesture)
        self.ibo_renderView.removeGestureRecognizer(pinchGesture)

    
    }
    
    //MARK: - Gesture Handlers
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var lastPinchScale: CGFloat = 1.0
    var currentlyScaling = false
    
    func stickyPinch(recognizer: UIPinchGestureRecognizer) {
        if let pic = self.importedPhoto {
            if recognizer.state == .Ended {
                currentlyScaling = false
                lastPinchScale = 1.0
                return
            }
            
            
            currentlyScaling = true
            
            let newScale = 1.0 - (lastPinchScale - recognizer.scale)
            
            let currentTransform:CGAffineTransform = self.importedPhoto.transform
            let newTransform = CGAffineTransformScale(currentTransform, newScale, newScale)
            
            self.importedPhoto.transform = newTransform
            
            lastPinchScale = recognizer.scale
            
        }
        
    }
    
    var lastMoveCenter = CGPoint(x: 0, y: 0)
    func stickyMove(recognizer: UIPanGestureRecognizer) {
        
        print(recognizer.translationInView(self.view))
        
        
        if self.vc_emojiScaleVC != nil {
            self.vc_emojiScaleVC.setValueSlider(recognizer.translationInView(self.view).x)
        }
        
        if let sticker = self.importedPhoto {
            
            
            var newCenter = recognizer.translationInView(self.view)
            
            if recognizer.state == .Began {
                
                lastMoveCenter = CGPointMake(self.importedPhoto.center.x, self.importedPhoto.center.y)
                
            }
            
            newCenter = CGPointMake(lastMoveCenter.x + newCenter.x, lastMoveCenter.y + newCenter.y)
            sticker.center = newCenter
            
        }
    }
    
    func showPhotoEdit(){
        
        ibo_renderView.userInteractionEnabled = true
        
        if vc_photoEditor == nil {
            
            vc_photoEditor = self.storyboard?.instantiateViewControllerWithIdentifier("sb_PhotoEditViewController") as! PhotoEditViewController
            vc_photoEditor.view.frame = CGRectMake(0, ibo_renderView.frame.origin.y, self.view.frame.width, 50)
            vc_photoEditor.delegate = self
        
        }
        self.view.addSubview(vc_photoEditor.view)
        ibo_bottomPhotoEdit.hidden = false
        
        self.ibo_drawView.userInteractionEnabled = false
        self.ibo_renderView.addGestureRecognizer(self.panGesture)
        self.ibo_renderView.addGestureRecognizer(self.pinchGesture)
    
    }
    
    func hidePhotoEdit(){
        
        ibo_renderView.userInteractionEnabled = false
        
        if vc_photoEditor != nil {
           vc_photoEditor.view.removeFromSuperview() 
        }
        
        ibo_bottomPhotoEdit.hidden = true
    
    }
    
    @IBAction func iba_doneEditingPhoto(){
        hidePhotoEdit()
        removeGesters()
        ibo_drawView.userInteractionEnabled = true
    }
    
    
    ////LONG TAP GESTURE
    func longTap(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .Ended {
            
            print("ENDED")
            self.vc_emojiScaleVC.view.removeFromSuperview()
            self.vc_emojiScaleVC = nil
            
            self.ibo_emojiButton.removeGestureRecognizer(self.panGesture)
        }
        
        if recognizer.state == .Began {
            
            self.ibo_emojiButton.addGestureRecognizer(self.panGesture)
            
            self.vc_emojiScaleVC = storyboard?.instantiateViewControllerWithIdentifier("sb_EmojiScaleViewController") as! EmojiScaleViewController
            self.vc_emojiScaleVC.view.frame = CGRectMake(0, self.view.frame.size.height - 244, self.view.frame.width, 200)
            self.vc_emojiScaleVC.selectedEmoji = self.ibo_emojiButton.imageForState(.Normal)
            self.vc_emojiScaleVC.setupIcons()
            self.view.addSubview(self.vc_emojiScaleVC.view)
            print("Began")
        }
        
    }
    
   


}