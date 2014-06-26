//
//  Game.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import SpriteKit

class Game: SKScene, SKPhysicsContactDelegate, UIAlertViewDelegate {

    var llama = Llama()
    var pyjamaCount = 0
    var startTime = NSDate()
    
    init(coder decoder: NSCoder!) {
        super.init(coder: decoder)
    }
    
    func playRect() -> CGRect {
        var rect = frame
        rect.size.height -= 240
        CGRectInset(rect, 80, 80)
        return rect
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playRect());
        
        restart()
    }
    
    func randomLocation(rect: CGRect) -> CGPoint {
        let x: CGFloat = CGFloat(arc4random_uniform(UInt32(CGRectGetWidth(rect))))
        let y: CGFloat = CGFloat(arc4random_uniform(UInt32(CGRectGetHeight(rect))))
        return CGPointMake(x, y)
    }

    func setup() {
        var rect = playRect()
        
        // add background
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
        background.anchorPoint = CGPointZero
        background.position = CGPointMake(0, -110)
        addChild(background)
        
        // add player
        llama.position = CGPoint(x:CGRectGetMidX(rect), y:CGRectGetMidY(rect));
        addChild(llama)
        
        // *** student will write code here
        
        // create 2 red pyjamas
        for i in 1...2 {
            let pyjama = Pyjama()
            pyjama.position = randomLocation(rect)
            pyjama.pyjamaColor = .red
            pyjamaCount++
            addChild(pyjama)
        }
        
        // create 3 green pyjamas
        for i in 1...3 {
            let pyjama = Pyjama()
            pyjama.position = randomLocation(rect)
            pyjama.pyjamaColor = .green
            pyjamaCount++
            addChild(pyjama)
        }
        
        // create 4 blue pyjamas
        for i in 1...4 {
            let pyjama = Pyjama()
            pyjama.position = randomLocation(rect)
            pyjama.pyjamaColor = .blue
            pyjamaCount++
            addChild(pyjama)
        }

        // create 3 lions
        for i in 1...3 {
            let lion = Lion()
            lion.position = randomLocation(rect)
            addChild(lion)
            lion.runningSpeed = 15
        }
    }
    
    func restart() {
        removeAllChildren()
        llama.health = 100
        llama.points = 0
        llama.resetPulse()
        setup()
        startTime = NSDate()
        pyjamaCount = 0
    }
    
    func llamaDied() {
        println("llama died")
        restart()
    }

    func gameCompleted() {
        let currentTime = NSDate()
        let diff = currentTime.timeIntervalSinceDate(startTime)
        println("game completed in \(diff) seconds")
        restart()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let destination = touch.locationInNode(self)

            let velocity: Double = 400
            let distance = sqrt(pow((Double(destination.x - llama.position.x)), 2.0) + pow((Double(destination.y - llama.position.y)), 2.0));
            let duration = distance / velocity
            llama.runAction(SKAction.moveTo(destination, duration:NSTimeInterval(duration)))

        }
    }
   
    func didBeginContact(contact: SKPhysicsContact!) {
        let otherNode = (contact.bodyA.node == llama) ? contact.bodyB.node : contact.bodyA.node
        
        if !otherNode.isKindOfClass(GameCharacter) {
            return
        }
        
        let character = otherNode as GameCharacter
        
        if character.isLion() {
            lionContacted(character as Lion)
        }
        else if character.isPyjama() {
            pyjamaContacted(character as Pyjama)
        }
        
        // TODO: display score/health/time on screen
        println("health: \(llama.health) points: \(llama.points)")
    }
    
    func lionContacted(lion: Lion) {
        // *** student will write code here

        // update health
        llama.health -= 30

        if llama.health <= 0 {
            llamaDied()
        }
        else if llama.health < 30 {
            llama.pulse()
        }
    }

    func pyjamaContacted(pyjama: Pyjama) {
        // *** student will write code here

        // update the score based on pyjama color
        switch pyjama.pyjamaColor {
        case .red:
            llama.points += 20
        case .green:
            llama.points += 10
        case .blue:
            llama.points += 5
        case .none:
            llama.points += 1
        }
        
        // make pyjama disappear
        pyjama.removeFromParent()
        
        // make llama wear pyjamas
        // TODO: implement Llama.wearPyjama(pyjama: Pyjama) once graphics are ready
        
        // update count of pyjamas remaining
        pyjamaCount--
        
        // check if the game is complete
        if pyjamaCount == 0 {
            gameCompleted()
        }
    }
   
    
}
