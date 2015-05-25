//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 11/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Custom cell for MemeCollectionViewController
class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.grayColor().CGColor
    }
    
    func setImage(image: UIImage) {
        
        var imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFit
        backgroundView = imageView
    }
}
