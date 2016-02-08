//
//  MonsterImage.swift
//  myLittleMonster
//
//  Created by Ian Boersma on 2/4/16.
//  Copyright © 2016 iboersma. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
     
        
    }
    
    func playIdleAnimation() {
        
        // set default image for monster
        self.image = UIImage(named: "idle1.png")
        
        // create temp array to store images for monster animation
        var imageArray = [UIImage]()
        
        // we run a for loop to iterate through the 4 "idle" images and assign each one to the variable...
        for var x = 1; x <= 4; x++ {
            let image = UIImage(named: "idle\(x).png")
            // we can force unwrap the image var as we know that we will always have these four images at load time
            imageArray.append(image!)
            
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        // value of zero means "infinite" repeat
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        // we set a default image so that when the monster dies, the screen
        // doesn't show the monster alive again
        self.image = UIImage(named: "dead5.png")
        
        // we empty out the animationImages collection to start fresh
        self.animationImages = nil
        
        // create temp array to store images for monster animation
        var imageArray = [UIImage]()
        
        // we run a for loop to iterate through the 4 "idle" images and assign each one to the variable...
        for var x = 1; x <= 5; x++ {
            let image = UIImage(named: "dead\(x).png")
            // we can force unwrap the image var as we know that we will always have these four images at load time
            imageArray.append(image!)
            
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        // we want the death animation to play only once
        
        self.animationRepeatCount = 1
        self.startAnimating()

    }
}