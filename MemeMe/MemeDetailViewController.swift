//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 11/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation
import UIKit

// Detail view controller for the meme
class MemeDetailViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Global variables
    var indexPath: NSIndexPath!
    
    // MARK: Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide tab bar
        tabBarController?.tabBar.hidden = true
        
        // Get image and display it in image view
        imageView.image = ((UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]).memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }

    // Launch meme editor to edit meme
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        // Grab the editorVC from Storyboard
        var editorVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
        
        // Pass the idexpath
        editorVC.indexPath = indexPath
        
        // Present the view controller using navigation
        navigationController!.pushViewController(editorVC, animated: true)
        
    }
    
    // Delete meme and go to previous view
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Delete Meme ?", message: "You are about to delete this Meme", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add delete action
        alert.addAction(UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            // Dismiss alert
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            // Delete meme
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(self.indexPath.row)
            
            // Pop the detail view controller
            self.navigationController!.popViewControllerAnimated(true)
        }))
        
        // Add cansel action
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Cancel, handler: { alertActio in
            
            // Dismiss alert
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))

        // Present the alert
        presentViewController(alert, animated: true, completion: nil)
    }
}
