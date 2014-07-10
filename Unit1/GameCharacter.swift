//
//  GameCharacter.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import Foundation
import SpriteKit

enum CharacterType: UInt32 {
    case llama = 0
    case pyjama = 1
    case lion = 2
    case edge = 4
}

class GameCharacter : SKSpriteNode {
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
        
        self.xScale = 0.5
        self.yScale = 0.5
        self.physicsBody = SKPhysicsBody(circleOfRadius: 25);
        self.physicsBody.dynamic = true
        self.physicsBody.affectedByGravity = false
        self.physicsBody.restitution = 1.0
        self.physicsBody.friction = 0
        self.physicsBody.linearDamping = 0
        self.physicsBody.angularDamping = 0
    }

    init(texture: SKTexture!) {
        super.init(texture: texture)
    }

    class func atlasName() -> String {
        return ""
    }
    
    class func framesFromAtlas(named atlasName: String) -> SKTexture[] {
        let atlas = SKTextureAtlas(named: atlasName)
        let textureNames = sort(atlas.textureNames as String[], { $0 < $1 } )

        let textures = textureNames.map {
            textureName -> SKTexture in
            return atlas.textureNamed(textureName as String)
        }
        
        return textures
    }

    func isLlama() -> Bool {
        return false;
    }

    func isLion() -> Bool {
        return false;
    }
    
    func isPyjama() -> Bool {
        return false;
    }
    
}
