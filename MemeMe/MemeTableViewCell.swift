//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 13/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Custom cell for MemeTableViewController
class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    @IBOutlet weak var imageV: UIImageView!
}
