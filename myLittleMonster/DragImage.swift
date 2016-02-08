//
//  DragImage.swift
//  myLittleMonster
//
//  Created by Ian Boersma on 2/4/16.
//  Copyright © 2016 iboersma. All rights reserved.
//

import Foundation
import UIKit

// We use this new class instead of the default UIImageView to handle touches (so we can do it in a custom way)
class DragImage: UIImageView {
    // variable to capture original x,y coordinates of where touch started
    var originalPosition: CGPoint!
    // We make a target for the dragged item (type UIView instead of UIImage to make it more flexible).  Note that we use the
    // optional notation here as we don't know whether the drag will get to the target.
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // make originalPosition = the center x,y point of this image view
        originalPosition = self.center
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // grab first UITouch object in touches set
        if let touch = touches.first {
            // grab the position in the superview where the touch happened
            let position = touch.locationInView(self.superview)
            // make the new center wherever the touch happened
            self.center = CGPointMake(position.x, position.y)
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // if there is a UITouch object AND if there is a target, then run the code
        if let touch = touches.first, let target = dropTarget {
            // grab position in superview where the touch happened
            let position = touch.locationInView(self.superview)
            // we see if the image being dragged is on top of the target
            // we pass in the target rectangle and then the position where we ended the touch
            if CGRectContainsPoint(target.frame, position) {
                // Method chaining.  "defaultCenter()" is a class (static) method that returns an NSNotificationCenter object/instance so that we can then invoke the
                // postNotification method on it
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil))
                
                
            }
        }
        
        self.center = originalPosition  
    }
}