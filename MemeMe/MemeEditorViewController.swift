//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 5/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MemeCropViewControllerDelegate {

    // MARK: Global variables
    var indexPath: NSIndexPath!
    
    // Meme text attributes dictionary
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomNavBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cropButton: UIBarButtonItem!
    
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the text delegates
        topText.delegate = self
        bottomText.delegate = self
        
        // Set the text and the text fields atributes
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        topText.borderStyle = UITextBorderStyle.None
        bottomText.borderStyle = UITextBorderStyle.None
        
        // Disable buttons
        shareButton.enabled = false
        cropButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide tab bar
        tabBarController?.tabBar.hidden = true
        
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        
        // Disable camera button if no camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Edit an existing meme
        if indexPath != nil {
            
            let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
            topText.text = meme.topText
            bottomText.text = meme.bottomText
            imageView.image = meme.image
        }

        // Disable share button and crop button if imageView has no image
        if imageView.image != nil {
            shareButton.enabled = true
            cropButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show nav bar
        tabBarController?.tabBar.hidden = false
        // Unsubcribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Push the view up when keyboard covers the bottom text field
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Push the view down when the keyboard hides
    func keyboardWillHide() {
        
        view.frame.origin.y = 0
    }
    
    // Get the keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: Image picker delegate methods
    // If user picks image, set image in imageView and dismiss controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // If user cancels, dismiss controller
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    // Select image from photo library
    @IBAction func imageFromLibrary(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }

    // Select image from camera
    @IBAction func imageFromCamera(sender: UIBarButtonItem) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Textfield delegate methods
    // Clear the textfield from default text when clicked
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
           textField.text = ""
        }
    }
    
    // Hide keyboard and lose focus when return is clicked
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Meme generation
    // Generate the memed image
    func generateMemedImage() -> UIImage{
        
        // Create image context
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, true, UIScreen.mainScreen().scale)
        
        // Get image view origin, navigation bar height, status bar height
        let origin = imageView.bounds.origin
        let navBarHeight = navigationController!.navigationBar.bounds.size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -origin.x, -origin.y - navBarHeight - statusBarHeight)
        
        // Render view to an image
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Clear image context
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // Create a meme object and add it to the memes array
    func save(memedImage:UIImage) {
        
        // Create the meme
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, image: imageView.image!, memedImage: memedImage)

        if indexPath == nil {
            
            // Add it to the memes array on the Application Delegate
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
            
        }else{
            
            // Replace the edited meme
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row] = meme
        }
    }
    
    // Share the meme
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let meme = generateMemedImage()
        
        // Define an instance of the ActivityViewController and pass the ActivityViewController a memedImage as an activity item
        let activityViewController = UIActivityViewController(activityItems: [meme as UIImage],applicationActivities: nil)
        
        // Present the controller
        presentViewController(activityViewController, animated: true, completion: nil)
        
        // Completion handler
        activityViewController.completionWithItemsHandler = {(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) in
            
            if !completed {
                
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
                
            }else{
                
                self.save(meme)
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func cropImage(sender: UIBarButtonItem) {
        
        // Grab the cropVC from Storyboard
        var cropVC = storyboard!.instantiateViewControllerWithIdentifier("MemeCropVC") as! MemeCropViewController
        
        // Pass the image
        cropVC.image = imageView.image
        // Delegate
        cropVC.delegate = self
        // Present the view controller using navigation
        navigationController!.pushViewController(cropVC, animated: true)
    }
    
    // Delegate to get the image back from crop
    func cropDidFinish(controller: MemeCropViewController, image: UIImage) {
        imageView.image = image
    }
}

