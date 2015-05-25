//
//  Meme.swift
//  MemeMe
//
//  Created by Dimitrios Gravvanis on 7/5/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Model for the Meme
struct Meme {
    
    let topText: String!
    let bottomText: String!
    let image: UIImage!
    let memedImage: UIImage!
    
    // Initialiser
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
