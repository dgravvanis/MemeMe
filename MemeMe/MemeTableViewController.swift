//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 11/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Table view controller for the memes
class MemeTableViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!

    
    // MARK: Global variables
    var hidden: Bool!

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
    }

    // MARK: Table view delegate methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
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
            self.tableView.backgroundView = placeholder
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        }else{
            // Enable edit button
            editButton.enabled = true
            // Remove placeholder message
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Dequeue the reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        
        // Get meme
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Pass index value to delete button
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Hide delete icon
        cell.deleteButton.hidden = hidden
        
        // Populate and return cell
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.imageV.contentMode = .ScaleAspectFit
        cell.imageV.image = meme.image
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get meme
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Grab the MemeDeatailViewController from Storyboard
        var detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
    
        //Populate view controller with data from the selected item
        detailVC.indexPath = indexPath
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    
    
    @IBAction func editTable(sender: UIBarButtonItem) {
        
        if hidden == true {
            
            editButton.image = UIImage(named: "DeleteFilledToolbarIcon")
            hidden = false
            
            let alert = UIAlertController(title: "Delete Memes", message: "You can delete multiple Memes by pressing the trash icon", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Add delete action
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { alertAction in
                
                // Dismiss alert
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                // Reload cells
                self.tableView.reloadData()
            }))
            
            // Present the alert
            self.presentViewController(alert, animated: true, completion: nil)
           
        }else{
            
            editButton.image = UIImage(named: "DeleteToolbarIcon")
            hidden = true
            // Reload cells
            self.tableView.reloadData()
        }

    }
    
    @IBAction func deleteCell(sender: UIButton) {
        
        // Get index
        let i: Int = (sender.layer.valueForKey("index")) as! Int
        
        // Delete the meme from array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(i)
        
        // Reload cells
        self.tableView.reloadData()
        
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
