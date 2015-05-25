//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 9/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Collection view controller for the memes
class MemeCollectionViewController : UICollectionViewController {
    
    // MARK: Global variables
    var hidden: Bool!
    @IBOutlet weak var editButton: UIBarButtonItem!

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.collectionView!.reloadData()
    }
    
    // MARK: Collection view delegate methods
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        let cellCount = (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
        
        if cellCount == 0 {
            
            // Disable edit button
            editButton.enabled = false
            editButton.image = UIImage(named: "DeleteToolbarIcon")
            
            // Configure and present a placeholder message
            var placeholder = UILabel()
            placeholder.text = "PRESS + TO MAKE YOUR MEME"
            placeholder.textColor = UIColor.blackColor()
            placeholder.numberOfLines = 1
            placeholder.textAlignment = NSTextAlignment.Center
            placeholder.font = UIFont(name: "Impact", size: 20)!
            placeholder.sizeToFit()
            self.collectionView!.backgroundView = placeholder
            return 0
        }else{
            // Enable edit button
            editButton.enabled = true
            // Remove placeholder message
            self.collectionView!.backgroundView = nil
            return 1
        }

    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return memes count
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        // Dequeue the reusable cell, use custom cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        // Get meme
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Pass index value to delete button
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Hide delete icon
        cell.deleteButton.hidden = hidden
        
        // Set the memed image as background
        cell.setImage(meme.memedImage)
        
        // Return cell
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Get meme
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Grab the DetailVC from Storyboard
        var detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailVC.indexPath = indexPath
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

    // MARK: Edit collection
    // Edit button, shows a delete icon in each cell
    @IBAction func editCollection(sender: UIBarButtonItem) {
        
        if hidden == true {
            
            editButton.image = UIImage(named: "DeleteFilledToolbarIcon")
            hidden = false
            
            let alert = UIAlertController(title: "Delete Memes", message: "You can delete multiple Memes by pressing the trash icon", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Add delete action
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { alertAction in
                
                // Dismiss alert
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                // Reload cells
                self.collectionView!.reloadData()
            }))
            
            // Present the alert
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            
            editButton.image = UIImage(named: "DeleteToolbarIcon")
            hidden = true
            // Reload cells
            self.collectionView!.reloadData()
        }
    }
    
    // Delete the cell
    @IBAction func deleteCell(sender: UIButton) {
        
        // Get index
        let i: Int = (sender.layer.valueForKey("index")) as! Int
        
        // Delete the meme from array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(i)
        
        // Reload cells
        self.collectionView!.reloadData()
        
        // Disable edit button when memes array is empty
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.isEmpty {
            editButton.image = UIImage(named: "DeleteToolbarIcon")
            editButton.enabled = false
        }
    }
    
    // Create new meme
    @IBAction func createMeme(sender: UIBarButtonItem) {
        
        // Present meme editor
        var editorVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
        self.navigationController!.pushViewController(editorVC, animated: true)
    }
}
