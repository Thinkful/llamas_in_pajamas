//
//  Lion.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import Foundation
import SpriteKit

var kLoadLionAssetsOnceToken: dispatch_once_t = 0
var kLionAnimationFrames = SKTexture[]()

class Lion : GameCharacter {

    var animationTimer: NSTimer?

    var runningSpeed: Int = 0 {
    willSet {

        if newValue > 0 {
            if let timer = self.animationTimer {
                timer.invalidate()
            }

            self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(CDouble(arc4random_uniform(10) + 1),
                target: self, selector: NSSelectorFromString("applyRandomMovement"),
                userInfo: nil, repeats: true)
        }
        
        self.physicsBody.applyImpulse(-self.physicsBody.velocity * self.physicsBody.mass)

        self.physicsBody.applyImpulse(CGVectorMakeRandomFromMagnitude(CGFloat(self.runningSpeed)) * self.physicsBody.mass)
    }

    didSet {
        if self.runningSpeed > 0 {
            applyRandomMovement()
        }
    }

    }

    convenience init() {
//        let image = UIImage(named: "Lion")
//        super.init(texture: SKTexture(image: image))
        
        self.init(texture: kLionAnimationFrames[0])
        self.name = "Lion"
        self.zPosition = 2

        self.physicsBody.categoryBitMask = CharacterType.lion.toRaw()
        self.physicsBody.contactTestBitMask = 0
        self.physicsBody.collisionBitMask = CharacterType.edge.toRaw() | CharacterType.llama.toRaw() | CharacterType.pyjama.toRaw()
        self.physicsBody.restitution = 0.6
        
        self.animate()
        
    }
  
    func removeTimer() {
      self.animationTimer?.invalidate()
      self.animationTimer = nil
    }

    func applyRandomMovement() {
        if let pBody = self.physicsBody {
            pBody.applyImpulse(-pBody.velocity * pBody.mass)

            pBody.applyImpulse(CGVectorMakeRandomFromMagnitude(CGFloat(self.runningSpeed)) * pBody.mass)
        }
    }


    func animate() {
        let animationAction = SKAction.animateWithTextures(kLionAnimationFrames, timePerFrame: 0.2, resize: true, restore: false)
        self.runAction(SKAction.repeatActionForever(animationAction), withKey: "lionRun")
    }
    
    override func isLion() -> Bool {
        return true;
    }

    class func loadAssets() {
        dispatch_once(&kLoadLionAssetsOnceToken) {
            kLionAnimationFrames = self.framesFromAtlas(named: "lion")
        }
    }
}
