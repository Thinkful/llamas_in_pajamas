//
//  Pyjama.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import Foundation
import SpriteKit

//let redColor = UIColor(hex: "E74C39")
//let greenColor = UIColor(hex: "3CD5AF")
//let blueColor = UIColor(hex: "0099FF")


enum PyjamaColor {
    case none
    case red
    case green
    case blue
    case purple
    case orange
    case yellow
    case black
    case brown
}

var kLoadPyjamaAssetsOnceToken: dispatch_once_t = 0
var kPyjamaAnimationFrames = SKTexture[]()

class Pyjama : GameCharacter {
    
    var pyjamaColor: PyjamaColor = PyjamaColor.none {
    didSet {
        switch pyjamaColor {
        case .none:
            self.color = UIColor(hex: "FFFFFF")
        case .red:
            self.color = UIColor(hex: "E74C39")
        case .green:
            self.color = UIColor(hex: "3CD5AF")
        case .blue:
            self.color = UIColor(hex: "0099FF")
        case .purple:
            self.color = UIColor(hex: "FF00FF")
        case .orange:
            self.color = UIColor(hex: "FFA500")
        case .yellow:
            self.color = UIColor(hex: "FFFF00")
        case .black:
            self.color = UIColor(hex: "000000")
        case .brown:
            self.color = UIColor(hex: "A52A2A")
        }
    }
    }

    convenience init() {
        
        self.init(texture: kPyjamaAnimationFrames[0])
        
        self.name = "Pyjama"
        self.physicsBody.categoryBitMask = CharacterType.pyjama.toRaw()
        self.physicsBody.contactTestBitMask = 0
        self.physicsBody.collisionBitMask = 0
        self.color = UIColor(hex: "FFFFFF")
        self.colorBlendFactor = 1.0
    }
    
    override func isPyjama() -> Bool {
        return true;
    }

    class func loadAssets() {
        dispatch_once(&kLoadPyjamaAssetsOnceToken) {
            kPyjamaAnimationFrames = self.framesFromAtlas(named: "pyjama")
        }
    }
}
