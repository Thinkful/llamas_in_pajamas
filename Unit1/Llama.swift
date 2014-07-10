//
//  Llama.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import Foundation
import SpriteKit

var kLoadLlamaAssetsOnceToken: dispatch_once_t = 0
var kLlamaIdleAnimationFrames = SKTexture[]()
var kLlamaWalkAnimationFrames = SKTexture[]()

class Llama : GameCharacter {
  
    var lives = 3
    var points: Int = 0
    var health: Int = 100 {
    didSet {
      
    }
    }
    
//    init(#texture: SKTexture!, #color: UIColor!, #size: CGSize) {
//        super.init(texture: texture, color: color, size: size)
//    }
//
//    init(#texture: SKTexture!) {
//        super.init(texture: texture)
//    }
//
    
    convenience init() {
        
        self.init(texture: kLlamaIdleAnimationFrames[0])

        self.name = "Llama"
        self.physicsBody.categoryBitMask = CharacterType.llama.toRaw()
        self.physicsBody.contactTestBitMask = CharacterType.pyjama.toRaw() | CharacterType.lion.toRaw()
        self.physicsBody.collisionBitMask = CharacterType.edge.toRaw()
        self.physicsBody.linearDamping = 1.5
        self.physicsBody.restitution = 0.1
        self.animate()
    }

    class func loadAssets() {
        dispatch_once(&kLoadLlamaAssetsOnceToken) {
            kLlamaIdleAnimationFrames = self.framesFromAtlas(named: "llama-idle")
            kLlamaWalkAnimationFrames = self.framesFromAtlas(named: "llama-walk")
        }
    }

    override class func atlasName() -> String {
        return "llama"
    }

    override func isLlama() -> Bool {
        return true;
    }
    
    func animate() {
        let animationAction = SKAction.animateWithTextures(kLlamaIdleAnimationFrames, timePerFrame: 0.05, resize: true, restore: false)
        self.runAction(SKAction.repeatActionForever(animationAction))
    }
  
    func walkAnimate(duration: Int) {
        let animationAction = SKAction.animateWithTextures(kLlamaWalkAnimationFrames, timePerFrame: 0.05, resize: true, restore: false)
        self.runAction(SKAction.repeatAction(animationAction, count: duration), completion: animate)
    }

    func pulse() {
            if let pulseAction = self.actionForKey("pulse") {
                println("already pulsing!")
            }
            else {
                let pulseRed = SKAction.sequence([
                    SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.55),
                    SKAction.waitForDuration(0.1),
                    SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.55)]);
                self.runAction(SKAction.repeatActionForever(pulseRed), withKey:"pulse");
            }
    }

    func resetPulse() {
        self.removeActionForKey("pulse")
        self.colorBlendFactor = 0
    }

}

