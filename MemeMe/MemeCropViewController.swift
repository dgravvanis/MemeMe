//
//  MemeCropViewController.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 24/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//


import UIKit

// Delegate protocol
protocol MemeCropViewControllerDelegate {
    
    func cropDidFinish(controller:MemeCropViewController, image: UIImage)
}

// Most of this code was found in this online tutorial ( https://www.youtube.com/watch?v=hz9pMw4Y2Lk )
class MemeCropViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {

    var delegate: MemeCropViewControllerDelegate! = nil
    
    // MARK: Global variables
    var image: UIImage!
    var imageView = UIImageView()
    
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Configure and add image view
        imageView.image = image
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        scrollView.addSubview(imageView)
        
        // Configure scroll view
        scrollView.contentSize = image.size
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Hide tab bar controller
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLayoutSubviews() {
        centerScrollViewContents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }

    // Center the imageView if it smaller than the scroll view
    func centerScrollViewContents() {
        
        // Get scroll views bound size
        let boundsSize = scrollView.bounds.size
        // Get image view frame
        var contentsFrame = imageView.frame
        
        // If image view size width is smaller, center in x axis
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        // If image view size height is smaller, center in y axis
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
    }
    
    // MARK: Scroll view delegate methods
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // Center the view
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // Crop the image and pop the controller
    @IBAction func cropImage(sender: UIBarButtonItem) {
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        
        // Set the origin
        let offset = scrollView.contentOffset
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y)
        
        // Render the cropped image and end image context
        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Pass the image
        delegate!.cropDidFinish(self, image: image)
        
        // Pop the crop view controller
        navigationController!.popViewControllerAnimated(true)
    }
}
