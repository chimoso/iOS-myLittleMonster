//
//  ViewController.swift
//  myLittleMonster
//
//  Created by Ian Boersma on 2/3/16.
//  Copyright © 2016 iboersma. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImage: MonsterImage!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    // set opacity (alpha channel) constants for skull graphics, as we will be making them
    // see-through or opaque depending upon the penalties received.
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    
    let MAX_PENALTIES = 3
    
    var penalties = 0
    // We know we will have a timer, so we can implicitly unwrap it here
    var timer: NSTimer!
    
    var monsterHappy = false
    
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBiteSound: AVAudioPlayer!
    var sfxHeartSound: AVAudioPlayer!
    var sfxDeathSound: AVAudioPlayer!
    var sfxSkullSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We set the target our observer is looking for for both the foodImage and the heartImage
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        // set all skull graphics to be see-through to start out with...
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA
        
        // We add an observer here to "listen" for the "onTargetDropped" event
        // Note:  We use "self" for the observer argument to indicate this class (ViewController) is the observer
        // The "selector" argumen provide the function to be executed when the observer registers the event "itemDroppedOnCharacter:".  Note that we use a colon at the end to indicate that
        // this function has one or more parameters (NSNotifications pass in a notification object as a parameter, so we must use the colon here). If we didn't include the coon, the observer would look for a function that did not have any params.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            // We create our first audio player.  Note that I've broken out each component here into separate variables just for ease or reading.  Normally, we would mash it all together
            // (see the other audio player instances below for examples of this).
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")
            let url = NSURL(fileURLWithPath: resourcePath!)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            // The smashed-together version of creating an audio player...
            try sfxBiteSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeartSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeathSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkullSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            sfxBiteSound.prepareToPlay()
            sfxHeartSound.prepareToPlay()
            sfxDeathSound.prepareToPlay()
            sfxSkullSound.prepareToPlay()
            
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        // We start the timer that checks the health of the monster every 3 seconds
        startTimer()
        
    }
    // We set up the function with a single parameter of type "AnyObject" as we don't know what particular type of object will be passed, though we do know that we are expecting
    // a notification object of some type.  We won't utilize the item passed in, so it's not a big deal.
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeartSound.play()
        } else {
            sfxBiteSound.play()
        }
        
    }
    
    func startTimer() {
        // We check to see if any other timer already exists and, if so, we invalidate it first
        if timer != nil {
            timer.invalidate()
        }
        // Every 3 seconds the "changeGameState" function will fire, to check whether the monster is happy or unhappy
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)

    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties++
            sfxSkullSound.play()
            
            if penalties == 1 {
                penalty1Image.alpha = OPAQUE
                penalty2Image.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty1Image.alpha = OPAQUE
                penalty2Image.alpha = OPAQUE
            } else if penalties >= 3 {
                penalty1Image.alpha = OPAQUE
                penalty2Image.alpha = OPAQUE
                penalty3Image.alpha = OPAQUE
            } else {
                penalty1Image.alpha = DIM_ALPHA
                penalty2Image.alpha = DIM_ALPHA
                penalty3Image.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        // We want a random range from 0 to 1 (ie: a range between 2 numbers) to randomly enable one item over the other
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            // remove ability for user to drag the food image around
            foodImage.userInteractionEnabled = false
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            foodImage.alpha = OPAQUE
            // remove ability for user to drag the food image around
            foodImage.userInteractionEnabled = true
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
        }
        
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        sfxDeathSound.play()
        foodImage.hidden = true
        heartImage.hidden = true
    }
    
    

}

