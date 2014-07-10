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
    var isPresentingViewController = false
    var gameWon = false
    var gameDelegate: GameDelegate?
    var shouldRestart = true

    init(coder decoder: NSCoder!) {
        super.init(coder: decoder)
    }

    func playRect() -> CGRect {
        var rect = frame
        rect.size.height -= 400
        rect.size.width -= 250
        rect.origin.x += 125
        rect.origin.y += 100
        return rect
    }
    
    override func didMoveToView(view: SKView) {
        initialize()
    }
    
    func randomLocation(rect: CGRect) -> CGPoint {
        let x: CGFloat = CGFloat(arc4random_uniform(UInt32(CGRectGetWidth(rect))))
        let y: CGFloat = CGFloat(arc4random_uniform(UInt32(CGRectGetHeight(rect))))
        return CGPointMake(x + rect.origin.x, y + rect.origin.y)
    }
    

    func setup() {
        let rect = playRect()

        // add background
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
        background.anchorPoint = CGPointZero
        background.position = CGPointMake(0, -110)
        addChild(background)

        // add player
        llama.position = CGPoint(x:CGRectGetMidX(rect), y:CGRectGetMidY(rect));
        addChild(llama)

        addCharacters()

        physicsWorld.contactDelegate = self

    }

    func initialize() {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playRect());
        pyjamaCount = 0
        llama.health = 100
        llama.points = 0
        gameWon = false
        startTime = NSDate()
        llama.resetPulse()
        setup()
    }

    func addCharacter(character: GameCharacter) {
        let rect = playRect()
        character.position = randomLocation(rect)
        addChild(character)
    }

    func addLion(lion: Lion, withSpeed speed: Int) {
        addCharacter(lion)
        lion.runningSpeed = speed
    }

    func addPyjama(pyjama: Pyjama) {
        addCharacter(pyjama)
        pyjamaCount++
    }

    func addCharacters() {
        // Implement this method!
    }

    func gameCompleted() {
        let currentTime = NSDate()
        let diff = currentTime.timeIntervalSinceDate(startTime)
        println("game completed in \(diff) seconds")
        
        // Remove timers from Lions
        for child: AnyObject in self.children {
            if child.isKindOfClass(GameCharacter) {
                let gChild = child as GameCharacter
                if gChild.isLion() {
                    let lChild = gChild as Lion
                    lChild.removeTimer()
                }
            }
        }
        removeAllChildren()
        
        gameDelegate?.gameDidFinish(self)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let destination = CGVectorMakeFromCGPoints(from: llama.position,
                                                       to: touch.locationInNode(self))


            // So many magic numbers in here... eventually this needs to be
            // refactored to actually calculate the correct momentum needed

            let momentumMagnitude = CGFloat(sqrt(CDouble(llama.physicsBody.linearDamping) *
                                         CDouble(CGVectorGetMagnitude(destination)) *
                                         CDouble(llama.physicsBody.mass) * CDouble(50)))

            let impulseVector = CGVectorNormalizedFromVector(destination) * momentumMagnitude
            llama.physicsBody.applyImpulse(-llama.physicsBody.velocity * llama.physicsBody.mass)
            llama.physicsBody.applyImpulse(impulseVector)
            llama.walkAnimate(Int(momentumMagnitude / 12))
        }
    }

    func didBeginContact(contact: SKPhysicsContact!) {

        if contact.bodyA.node == llama {
            let otherNode = contact.bodyB.node

            if !otherNode.isKindOfClass(GameCharacter) {
                return
            }
            handleLlamaCollisions(otherNode as GameCharacter)

        } else if contact.bodyB.node == llama {
            let otherNode = contact.bodyA.node

            if !otherNode.isKindOfClass(GameCharacter) {
                return
            }
            handleLlamaCollisions(otherNode as GameCharacter)
        }
        checkGameComplete()
    }
  
  
    func handleLlamaCollisions(character: GameCharacter) {
        if character.isLion() {
            lionContacted(character as Lion)
        } else if character.isPyjama() {
            pyjamaContacted(character as Pyjama)
        }
    }

    func lionContacted(lion: Lion) {
        llama.health -= 10
        if llama.health < 50 {
            llama.pulse()
        }
    }

    func pyjamaContacted(pyjama: Pyjama) {
        // Implement this method!
    }

    func checkGameComplete() {
        if pyjamaCount <= 0 {
            gameWon = true
            showGameOverMessage()
        }
        if llama.health <= 0 {
            showGameOverMessage()
        }
    }

    func showGameOverMessage() {
        self.physicsWorld.contactDelegate = nil
        var gameOverAlert = UIAlertController(title: gameWon ? "You Won!" : "Game Over!",
          message: gameWon ? "Great job! Start again?" : "You died! Would you like to restart?",
          preferredStyle: UIAlertControllerStyle.Alert)

        gameOverAlert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: gameOverAlertConfirmPressed))
        gameOverAlert.addAction(UIAlertAction(title: "Quit",
            style: UIAlertActionStyle.Cancel, handler: gameOverAlertCancelPressed))

        if !isPresentingViewController {
          isPresentingViewController = true
          self.view.window.rootViewController.presentViewController(gameOverAlert, animated: true, completion: { self.isPresentingViewController = false })
        }
    }

    func gameOverAlertConfirmPressed(sender: UIAlertAction?) {
        shouldRestart = true
        gameCompleted()
    }
    
    func gameOverAlertCancelPressed(sender: UIAlertAction?) {
        shouldRestart = false
        gameCompleted()
    }
}
