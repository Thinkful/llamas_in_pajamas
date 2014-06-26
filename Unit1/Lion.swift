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
    
    var runningSpeed: Int = 0 {
    didSet {
        self.physicsBody.applyImpulse(CGVectorMake(CGFloat(runningSpeed), CGFloat(runningSpeed)))
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
        self.physicsBody.collisionBitMask = CharacterType.edge.toRaw()
        
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
