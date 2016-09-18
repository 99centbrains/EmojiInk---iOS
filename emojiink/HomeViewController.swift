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
    
    @IBOutlet weak var ibo_btn_undo:UIButton!
    @IBOutlet weak var ibo_btn_redo:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ibo_bottomPhotoEdit.isHidden = true
        
        //GESTURES FOR PHOTO IMPORT
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(HomeViewController.stickyMove(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(HomeViewController.stickyPinch(_:)))
        
        panGesture.delegate = self
        pinchGesture.delegate = self
        
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        
        longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.longTap(_:)))
        longTapGesture.delegate = self
        longTapGesture.minimumPressDuration = 1.0
        ibo_emojiButton.addGestureRecognizer(longTapGesture)
        
        
        ibo_renderView.isUserInteractionEnabled = true
        
        
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        currentEmoji = UIImage(named: "emoji_start")
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ibo_drawView.isActive == false {
        
            ibo_drawView.setUp()
            ibo_drawView.currImage = currentEmoji.cgImage
            ibo_emojiButton.setImage(UIImage(cgImage: ibo_drawView.currImage!), for: UIControlState())
            
            ibo_drawView.btn_redo = ibo_btn_redo
            ibo_drawView.btn_undo = ibo_btn_undo
            
        
        }
        
        //handleEmojiPress();
    }
    
    @IBAction func iba_clearCanvas(){
        
        let alert = UIAlertController(title: "💣💣💣💣💣💣💣", message: "Are you 💯 you want to start all over?", preferredStyle: .alert);
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.ibo_drawView.destroyImage()
            self.photoTrash()
            
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil);
        }
        
        alert.addAction(yesAction);
        alert.addAction(noAction);
        
        self.present(alert, animated: true, completion: nil);
    
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
            
            vc_emojiSelect = self.storyboard?.instantiateViewController(withIdentifier: "sb_EmojiSelectViewController") as! EmojiSelectViewController
            vc_emojiSelect.selectedEmoji = UIImage(cgImage: ibo_drawView.currImage!)
            vc_emojiSelect.delegate = self
            
        }
        
        self.view.addSubview(vc_emojiSelect.view)
        
        removeGesters()

    }
    
    func emojiDidFinish(_ emoji:UIImage, size:CGFloat){
        
        print("did finish");
        
        vc_emojiSelect.view.removeFromSuperview()
        
        currentEmoji = emoji
        
        ibo_emojiButton.setImage(emoji, for: UIControlState())
        ibo_drawView.currImage = currentEmoji.cgImage
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
    
    @IBAction func iba_canvasSAVE(_ sender:UIBarButtonItem){
        
        
        renderImage { (image:UIImage) -> () in
            
            
            var items = [AnyObject]()
            let activities = [UIActivity]()
            
            items.append(image)
            items.append("#EmojiInk" as AnyObject)
            
            
            let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
            controller.popoverPresentationController?.sourceView = self.view
            
            
            self.present(controller, animated: true, completion: nil)
            
            
        }
        
    }
    
    //SAVE IMAGE
    func renderImage(_ callback: @escaping (UIImage) -> ()) {
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            if self.importedPhoto != nil {
            if self.importedPhoto.alpha < 1  {
                self.importedPhoto.isHidden = true
            }
            }
            
            
            
            UIGraphicsBeginImageContextWithOptions(self.ibo_drawView.frame.size, false, 0.0)
            self.ibo_drawView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let drawRender = UIImageView(image: drawImage)
            drawRender.frame = CGRect(x: 0, y: 0, width: self.ibo_drawView.frame.size.width, height: self.ibo_drawView.frame.size.height)
            
            self.ibo_renderView.addSubview(drawRender)
            
            
            UIGraphicsBeginImageContextWithOptions(self.ibo_renderView.frame.size, false, 0.0)
            self.ibo_renderView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            drawRender.removeFromSuperview()
            callback(image!)
            
            
            
            if self.importedPhoto != nil {
                self.importedPhoto.isHidden = false
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
                preferredStyle: .actionSheet)
            
            //let picker = UIImagePickerController()
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default)
                { action -> Void in
                    self.showPhotoEdit()
            }
            
            actionSheetController.addAction(takePictureAction)
            //Create and add a second option action
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Delete Image", style: .default)
                { action -> Void in
                    self.photoTrash()
            }
            
            actionSheetController.addAction(choosePictureAction)
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = self.view
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)

            return
        
        }
        
        let actionSheetController: UIAlertController = UIAlertController(
            title: "Import Photo",
            message: nil,
            preferredStyle: .actionSheet)
        
        let picker = UIImagePickerController()
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default)
            { action -> Void in
                
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
                
                
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take A Picture", style: .default)
            { action -> Void in
                
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
                
                
        }
        actionSheetController.addAction(takePictureAction)
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = self.view
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker.dismiss(animated: true) { () -> Void in
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            self.importedPhoto = UIImageView(frame: self.ibo_drawView.frame)
            self.importedPhoto.contentMode = .scaleAspectFill
            self.importedPhoto.image = image
            self.importedPhoto.isUserInteractionEnabled = false
            self.ibo_renderView.insertSubview(self.importedPhoto, belowSubview: self.ibo_drawView)
            
            self.showPhotoEdit()
            

        }
    
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        picker.dismiss(animated: true, completion: nil)
    
    }
    
    func photoTrash(){
        
        self.hidePhotoEdit()
        if self.importedPhoto != nil {
            self.importedPhoto.removeFromSuperview()
        }
        self.importedPhoto = nil
        self.ibo_drawView.isUserInteractionEnabled = true
        
        removeGesters()
        
    }
    
    func photoOverlayToggle(_ toggle:Bool){
        
        
        if toggle == true {
            
            self.importedPhoto.alpha = 1.0

        } else {
            
            self.importedPhoto.alpha = 0.5
            
        }
        
        self.view.exchangeSubview(at: 0, withSubviewAt: 1)
    
    }
    
    func photoMoveScale(_ toggle:Bool){
        
        
    
    }
    
    func removeGesters(){
        
        self.ibo_renderView.removeGestureRecognizer(panGesture)
        self.ibo_renderView.removeGestureRecognizer(pinchGesture)

    
    }
    
    //MARK: - Gesture Handlers
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var lastPinchScale: CGFloat = 1.0
    var currentlyScaling = false
    
    func stickyPinch(_ recognizer: UIPinchGestureRecognizer) {
        if (self.importedPhoto) != nil {
            if recognizer.state == .ended {
                currentlyScaling = false
                lastPinchScale = 1.0
                return
            }
            
            
            currentlyScaling = true
            
            let newScale = 1.0 - (lastPinchScale - recognizer.scale)
            
            let currentTransform:CGAffineTransform = self.importedPhoto.transform
            let newTransform = currentTransform.scaledBy(x: newScale, y: newScale)
            
            self.importedPhoto.transform = newTransform
            
            lastPinchScale = recognizer.scale
            
        }
        
    }
    
    var lastMoveCenter = CGPoint(x: 0, y: 0)
    func stickyMove(_ recognizer: UIPanGestureRecognizer) {
        
        print(recognizer.translation(in: self.view))
        
        
        if self.vc_emojiScaleVC != nil {
            self.vc_emojiScaleVC.setValueSlider(recognizer.translation(in: self.view).x)
        }
        
        if let sticker = self.importedPhoto {
            
            
            var newCenter = recognizer.translation(in: self.view)
            
            if recognizer.state == .began {
                
                lastMoveCenter = CGPoint(x: self.importedPhoto.center.x, y: self.importedPhoto.center.y)
                
            }
            
            newCenter = CGPoint(x: lastMoveCenter.x + newCenter.x, y: lastMoveCenter.y + newCenter.y)
            sticker.center = newCenter
            
        }
    }
    
    func showPhotoEdit(){
        
        ibo_renderView.isUserInteractionEnabled = true
        
        if vc_photoEditor == nil {
            
            vc_photoEditor = self.storyboard?.instantiateViewController(withIdentifier: "sb_PhotoEditViewController") as! PhotoEditViewController
            vc_photoEditor.view.frame = CGRect(x: 0, y: ibo_renderView.frame.origin.y, width: self.view.frame.width, height: 50)
            vc_photoEditor.delegate = self
        
        }
        self.view.addSubview(vc_photoEditor.view)
        ibo_bottomPhotoEdit.isHidden = false
        
        self.ibo_drawView.isUserInteractionEnabled = false
        self.ibo_renderView.addGestureRecognizer(self.panGesture)
        self.ibo_renderView.addGestureRecognizer(self.pinchGesture)
    
    }
    
    func hidePhotoEdit(){
        
        ibo_renderView.isUserInteractionEnabled = false
        
        if vc_photoEditor != nil {
           vc_photoEditor.view.removeFromSuperview() 
        }
        
        ibo_bottomPhotoEdit.isHidden = true
    
    }
    
    @IBAction func iba_doneEditingPhoto(){
        hidePhotoEdit()
        removeGesters()
        ibo_drawView.isUserInteractionEnabled = true
    }
    
    
    ////LONG TAP GESTURE
    func longTap(_ recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .ended {
            
            print("ENDED")
            self.vc_emojiScaleVC.view.removeFromSuperview()
            self.vc_emojiScaleVC = nil
            
            self.ibo_emojiButton.removeGestureRecognizer(self.panGesture)
        }
        
        if recognizer.state == .began {
            
            self.ibo_emojiButton.addGestureRecognizer(self.panGesture)
            
            self.vc_emojiScaleVC = storyboard?.instantiateViewController(withIdentifier: "sb_EmojiScaleViewController") as! EmojiScaleViewController
            self.vc_emojiScaleVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height - 244, width: self.view.frame.width, height: 200)
            self.vc_emojiScaleVC.selectedEmoji = self.ibo_emojiButton.image(for: UIControlState())
            self.vc_emojiScaleVC.setupIcons()
            self.view.addSubview(self.vc_emojiScaleVC.view)
            print("Began")
        }
        
    }
    
   


}
