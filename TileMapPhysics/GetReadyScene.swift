//
//  GetReadyScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/3/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit
import GameplayKit


class GetReadyScene: SKScene {

    var month = 1
    var level = 0
    var touch = false
    var bonus = false
    let sounds = SoundEffects()
    
    var cursorX = -170.0
    var cursorY = 70.0
    
    var cursorSprite : SKSpriteNode?

    
    
    // Called when view appears..
    override func didMove(to view: SKView) {
        
        // Using the highest level recorded, set alpha on unlocked level buttons
        
        cursorSprite = childNode(withName: "root/cursor") as! SKSpriteNode?
        
        #if os(tvOS)
           childNode(withName: "root")?.setScale(2.6)
            
            
            if let recognizers = view.gestureRecognizers {
                for recognizer in recognizers {
                    view.removeGestureRecognizer(recognizer as UIGestureRecognizer)
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)
            
            
            let swipeRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp))
            swipeRecognizerUp.direction = .up
            view.addGestureRecognizer(swipeRecognizerUp)
            
            let swipeRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown))
            swipeRecognizerDown.direction = .down
            view.addGestureRecognizer(swipeRecognizerDown)

            
            let swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft))
            swipeRecognizerLeft.direction = .left
            view.addGestureRecognizer(swipeRecognizerLeft)

            
            let swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
            swipeRecognizerRight.direction = .right
            view.addGestureRecognizer(swipeRecognizerRight)
            
   /*
            let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.menu))
            tapRecognizer2.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)];
            self.view?.addGestureRecognizer(tapRecognizer2)

            self.view?.removeGestureRecognizer(tapRecognizer2)
*/
             cursorSprite?.position = CGPoint(x: cursorX, y: cursorY)
            
            
            
            #else
            
            cursorSprite?.isHidden = true
            
        #endif
        
        
         level = Settings().Load()
        
        touch = false
        
    
        if level >= 1  {childNode(withName: "root/Jan")?.alpha = 1.0}
        if level >= 2  {childNode(withName: "root/Feb")?.alpha = 1.0} else {childNode(withName: "root/Feb")?.alpha = 0.2}
        if level >= 3  {childNode(withName: "root/Mar")?.alpha = 1.0} else {childNode(withName: "root/Mar")?.alpha = 0.2}
        if level >= 4  {childNode(withName: "root/Apr")?.alpha = 1.0} else {childNode(withName: "root/Apr")?.alpha = 0.2}
        if level >= 5  {childNode(withName: "root/May")?.alpha = 1.0} else {childNode(withName: "root/May")?.alpha = 0.2}
        if level >= 6  {childNode(withName: "root/Jun")?.alpha = 1.0} else {childNode(withName: "root/Jun")?.alpha = 0.2}
        if level >= 7  {childNode(withName: "root/Jul")?.alpha = 1.0} else {childNode(withName: "root/Jul")?.alpha = 0.2}
        if level >= 8  {childNode(withName: "root/Aug")?.alpha = 1.0} else {childNode(withName: "root/Aug")?.alpha = 0.2}
        if level >= 9  {childNode(withName: "root/Sep")?.alpha = 1.0} else {childNode(withName: "root/Sep")?.alpha = 0.2}
        if level >= 10 {childNode(withName: "root/Oct")?.alpha = 1.0} else {childNode(withName: "root/Oct")?.alpha = 0.2}
        if level >= 11 {childNode(withName: "root/Nov")?.alpha = 1.0} else {childNode(withName: "root/Nov")?.alpha = 0.2}
        if level >= 12 {childNode(withName: "root/Dec")?.alpha = 1.0} else {childNode(withName: "root/Dec")?.alpha = 0.2}
        
        
        let zoomout = SKAction.moveBy(x: 0, y: -10, duration: 0.25)
        let pause = SKAction.wait(forDuration: 0.50)
        let zoomin = SKAction.moveBy(x: 0, y: 10, duration: 0.25)


        childNode(withName: "root/Jan")?.run(SKAction.repeatForever(SKAction.sequence([zoomin,zoomout,pause,pause,pause,pause,pause,pause,pause,pause,pause,pause,pause])))
        childNode(withName: "root/Feb")?.run(SKAction.repeatForever(SKAction.sequence([pause,zoomin,zoomout,pause,pause,pause,pause,pause,pause,pause,pause,pause,pause])))
        childNode(withName: "root/Mar")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,zoomin,zoomout,pause,pause,pause,pause,pause,pause,pause,pause,pause])))
        childNode(withName: "root/Apr")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,zoomin,zoomout,pause,pause,pause,pause,pause,pause,pause,pause])))
        childNode(withName: "root/May")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,zoomin,zoomout,pause,pause,pause,pause,pause,pause,pause])))
        childNode(withName: "root/Jun")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,zoomin,zoomout,pause,pause,pause,pause,pause,pause])))
        childNode(withName: "root/Jul")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,pause,zoomin,zoomout,pause,pause,pause,pause,pause])))
        childNode(withName: "root/Aug")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,pause,pause,zoomin,zoomout,pause,pause,pause,pause])))
        childNode(withName: "root/Sep")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,pause,pause,pause,zoomin,zoomout,pause,pause,pause])))
        childNode(withName: "root/Oct")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,pause,pause,pause,pause,zoomin,zoomout,pause,pause])))
        childNode(withName: "root/Nov")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,pause,pause,pause,pause,pause,zoomin,zoomout,pause])))
        childNode(withName: "root/Dec")?.run(SKAction.repeatForever(SKAction.sequence([pause,pause,pause,pause,pause,pause,pause,pause,pause,pause,pause,zoomin,zoomout])))

        // Bonus levels
        
        childNode(withName: "root/Bonus1")?.alpha = 0.2
        childNode(withName: "root/Bonus1l")?.alpha = 0.2
        childNode(withName: "root/Bonus2")?.alpha = 0.2
        childNode(withName: "root/Bonus2l")?.alpha = 0.2
        childNode(withName: "root/Bonus3")?.alpha = 0.2
        childNode(withName: "root/Bonus3l")?.alpha = 0.2
        childNode(withName: "root/Bonus4")?.alpha = 0.2
        childNode(withName: "root/Bonus4l")?.alpha = 0.2
        childNode(withName: "root/Bonus5")?.alpha = 0.2
        childNode(withName: "root/Bonus5l")?.alpha = 0.2
        childNode(withName: "root/Bonus6")?.alpha = 0.2
        childNode(withName: "root/Bonus6l")?.alpha = 0.2
    
        if level > 2
        {
            childNode(withName: "root/Bonus1")?.alpha = 1.0
            childNode(withName: "root/Bonus1l")?.alpha = 1.0
        }
    
        if level > 4
        {
            childNode(withName: "root/Bonus2")?.alpha = 1.0
            childNode(withName: "root/Bonus2l")?.alpha = 1.0
        }
        
        if level > 6
        {
            childNode(withName: "root/Bonus3")?.alpha = 1.0
            childNode(withName: "root/Bonus3l")?.alpha = 1.0
        }
        
        if level > 8
        {
            childNode(withName: "root/Bonus4")?.alpha = 1.0
            childNode(withName: "root/Bonus4l")?.alpha = 1.0
        }
        
        if level > 10
        {
            childNode(withName: "root/Bonus5")?.alpha = 1.0
            childNode(withName: "root/Bonus5l")?.alpha = 1.0
        }
        
        if level > 11
        {
            childNode(withName: "root/Bonus6")?.alpha = 1.0
            childNode(withName: "root/Bonus6l")?.alpha = 1.0
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touch { return; }
        
           #if os(tvOS)
            return
            #endif
        
        
        touch = true
        
        let positionInScene = touches.first?.location(in: self)
    
        let trouchedNode = self.nodes(at: positionInScene!)
        
        if trouchedNode.first?.name == nil
        {
            return
        }
        

        
        switch (trouchedNode.first?.name)!
        {
            case "Logo" : month = 0
            case "Jan" : month = 1
            case "Feb" : month = 2
            case "Mar" : month = 3
            case "Apr" : month = 4
            case "May" : month = 5
            case "Jun" : month = 6
            case "Jul" : month = 7
            case "Aug" : month = 8
            case "Sep" : month = 9
            case "Oct" : month = 10
            case "Nov" : month = 11
            case "Dec" : month = 12
            
            case "Bonus1" :  month = 1; bonus = true
            case "Bonus2" :  month = 2; bonus = true
            case "Bonus3" :  month = 3; bonus = true
            case "Bonus4" :  month = 4; bonus = true
            case "Bonus5" :  month = 5; bonus = true
            case "Bonus6" :  month = 6; bonus = true

            case "Settings" :  month = 100

            
            default: month = 0
        }
        
        // Only tap buttons
        if (month == 0)
        {
            return
        }
        
        // Only tap unlocked buttons
        if (trouchedNode.first?.alpha != 1.0)
        {
            return
        }
        
        
        if (month == 100)
        {
            let settingsS = SettingsScene(fileNamed: "SettingsScene")
             let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(settingsS!, transition: transition)
            return
        }

        
        // Pressed! Now Pulse button..
        
        let tiltIn = SKAction.scaleY(to: 0.9, duration: 0.05)
        let zoomout = SKAction.scale(by: 0.8, duration: 0.1)
        let zoombounce = SKAction.scale(by: 1.4, duration: 0.1)
        let zoomin = SKAction.scale(to: 1.0, duration: 0.1)
        let tiltOut = SKAction.scaleY(to: 1, duration: 0.05)
        let rb = SKAction.run({ self.moveToGame()})
        
        let Sequence = SKAction.sequence([tiltIn, zoomout, zoombounce, zoomin, tiltOut, rb])

         trouchedNode.first?.run(Sequence)
    
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
    }
    
    
    func swipedUp()
    {
        
        // At the top, move to settings
        if cursorY == 70
        {
            cursorX = 254
            cursorY = 140
            updateCursor()
            return
        }
        
        if cursorY < 70
        {
            cursorY += 65
            updateCursor()
            return
            
        }

        
    }
    
    func swipedDown()
    {
     
        
        // At Settings, go to level 1
        if cursorY == 140
        {
            cursorX = -170
            cursorY = 70
            updateCursor()
            return
        }
        
        if cursorY > -55
        {
            cursorY -= 65
            updateCursor()
            return
            
        }

    }
    
    func swipedLeft()
    {
        
        // if at settings, go to level 6
        if cursorY == 140
        {
            cursorX = 180
            cursorY = 70
            updateCursor()
            return
        }
        
        if cursorX > -170
        {
            cursorX -= 70
            updateCursor()
            return
        }

    }
    
    func swipedRight()
    {
        
        if cursorY == 140
        {
            return
        }
        
        if cursorX < 180
        {
            cursorX += 70
            updateCursor()
            return
        }
        
    }
    
    func menu()
    {
        print("Menu")
    }
    
    func tapped()
    {
        if (month == 100)
        {
            let settingsS = SettingsScene(fileNamed: "SettingsScene")
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(settingsS!, transition: transition)
            return
        }
        moveToGame()
    }

    func updateCursor()
    {
        cursorSprite?.run(SKAction.move(to: CGPoint(x:CGFloat(cursorX), y: CGFloat(cursorY)), duration: 0.15))
        
        let x = ( Int(cursorX) + 170) / 70
        let y = ( Int(cursorY) - 70) / -65
        var l = x + (y * 6)
        
        if cursorY == 140
        {
            l = 99
        }
        
        month = l + 1
        
    }
    
    
    func moveToGame()
    {
    
        if month == 0
        {
            print("false start, month is 0")
            return
        }
        
        if month > level
        {
            return
        }
        
        
        self.run(sounds.ping)
        
        
        print ("Going to start level \(month)")
        
        var scene : GameScene? = nil
        
      
        
        if !bonus
        {
            
              scene = GameScene(fileNamed: "GameSceneLevel3")!
              scene?.gameLevel = month
            
           
        }
        else
        {
           
            
            if month == 1 { scene?.gameLevel = 1;scene = GameScene(fileNamed: "GameBonusLevel1")!}
            if month == 2 { scene?.gameLevel = 3;scene = GameScene(fileNamed: "GameBonusLevel2")!}
            if month == 3 { scene?.gameLevel = 5;scene = GameScene(fileNamed: "GameBonusLevel3")!}
            
            
            if month == 4 { scene?.gameLevel = 6;scene = GameScene(fileNamed: "GameBonusLevel4")!}
            if month == 5 { scene?.gameLevel = 7;scene = GameScene(fileNamed: "GameBonusLevel5")!}
            if month == 6 { scene?.gameLevel = 8;scene = GameScene(fileNamed: "GameBonusLevel6")!}

              scene?.bonusLevel = bonus
            
        }
       
        
    
        scene?.currentGameState = .starting
       
        let transition = SKTransition.fade(with: UIColor.black, duration: 1)
        self.view?.presentScene(scene!, transition: transition)
    }
    
    
}

