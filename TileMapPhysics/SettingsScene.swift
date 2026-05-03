//
//  GetReadyScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/3/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit
import UIKit
import GameplayKit
import GameController

class SettingsScene: SKScene {

    var button = 0
    var touch = false
    let sounds = SoundEffects()
    var settings = Settings()
    var level = 0
    var selected = 0
    var gameController: GCController?

    var backSprite : SKSpriteNode?
    var option1Sprite : SKLabelNode?
    var option2Sprite : SKLabelNode?
    
    // Called when view appears..
    override func didMove(to view: SKView) {
        
        
        backSprite = childNode(withName: "root/Back") as? SKSpriteNode
        option1Sprite = childNode(withName: "root/daynight") as? SKLabelNode
        option2Sprite = childNode(withName: "root/soundeffects") as? SKLabelNode
        
        updateCursor()
        
        #if os(tvOS)
            childNode(withName: "root")?.setScale(2.6)
            
            
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
            let tapRecognizer1 = UITapGestureRecognizer(target: self, action: "tv_remote_tapped:")
            tapRecognizer1.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)];
            self.view?.addGestureRecognizer(tapRecognizer1)
            
            let tapRecognizer2 = UITapGestureRecognizer(target: self, action: "tv_remote_menu:")
            tapRecognizer2.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)];
            self.view?.addGestureRecognizer(tapRecognizer2)
            */


            
            
            
        #endif
            
        // Using the highest level recorded, set alpha on unlocked level buttons
        
        level = settings.Load()
        ButtonAppearance()
        touch = false
 
        setupControllerObservers()
        
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            if item.type == .menu {
                Goback()
            }
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
            
        case "Back" :  button = 1
        case "Logo" : return
        case "daynight" : button = 2
        case "soundeffects" : button = 3
            
            
        default: return
        }
        
        
        // Only tap buttons
        if button == 0
        {
            return
        }

        
        
        // Pressed! Now Pulse button..
        
        let tiltIn = SKAction.scaleY(to: 0.9, duration: 0.05)
        let zoomout = SKAction.scale(by: 0.8, duration: 0.1)
        let zoombounce = SKAction.scale(by: 1.4, duration: 0.1)
        let zoomin = SKAction.scale(to: 1.0, duration: 0.1)
        let tiltOut = SKAction.scaleY(to: 1, duration: 0.05)
        
        let Sequence = SKAction.sequence([tiltIn, zoomout, zoombounce, zoomin, tiltOut])

         trouchedNode.first?.run(Sequence)
        
        if button == 1
        {
            Goback()
        }
        
        if button == 2
        {
            toggleDayNight()
        }
        
        if button == 3
        {
            toggleSoundEffects()
        }
        
     
    
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
    }
    
    
    func Goback()
    {
        self.run(sounds.ping)
        let scene  = GameScene(fileNamed: "GetReadyScene")!
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(scene, transition: transition)
    }
    
    func ButtonAppearance() // need to define these better
    {
        if  settings.DayNightMode == false
        {
            option1Sprite?.text = "Daylight only"
            childNode(withName: "daynight")?.alpha = 0.2
        }
        else
        {
            option1Sprite?.text = "Day and night"
            childNode(withName: "daynight")?.alpha = 1.0
        }

        if settings.AudioEffects == false
        {
            option2Sprite?.text = "Awful SFX: Off"
            childNode(withName: "soundeffects")?.alpha = 0.2
        }
        else
        {
             option2Sprite?.text = "Awful SFX: On"
             childNode(withName: "soundeffects")?.alpha = 1.0
        }
        
    }
    
    func toggleDayNight()
    {
        self.run(sounds.ping)
        
        
        if  settings.DayNightMode == true
        {
            settings.DayNightMode = false
        }
        else
        {
            settings.DayNightMode = true
        }

        ButtonAppearance()
        settings.SaveLevel(level: level)
    }
    
    func toggleSoundEffects()
    {
        self.run(sounds.ping)
       
        if  settings.AudioEffects == true
        {
            settings.AudioEffects = false
        }
        else
        {
            settings.AudioEffects = true
        }
        
        ButtonAppearance()
        settings.SaveLevel(level: level)
    }
    
    
    @objc func swipedUp()
    {
        
       if selected == 2
       {
        selected = 1
        }
        
        updateCursor()
        
    }
    
    @objc func swipedDown()
    {
        if selected == 1
        {
            selected = 2
        }
        
        updateCursor()
    }
    
    @objc func swipedLeft()
    {
        if selected == 1 || selected == 2

        {
            selected = 0
        }
        
        updateCursor()
    }
    
    @objc func swipedRight()
    {
        if selected == 0
        {
            selected = 1
        }
        updateCursor()
    }
    
    func menu()
    {
        
    }
    
    func updateCursor()
    {
        let son : CGFloat = 1.0
        let soff : CGFloat = 0.25
        
        if selected == 0
        {
            backSprite?.alpha = son
            option1Sprite?.alpha = soff
            option2Sprite?.alpha = soff
        }
        
        if selected == 1
        {
            backSprite?.alpha = soff
            option1Sprite?.alpha = son
            option2Sprite?.alpha = soff
        }

        
        if selected == 2
        {
            backSprite?.alpha = soff
            option1Sprite?.alpha = soff
            option2Sprite?.alpha = son
        }

    }
    
    @objc func tapped()
    {
        if selected == 0
        {
            Goback()
        }
        
        if selected == 1
        {
            toggleDayNight()
        }
        
        if selected == 2
        {
            toggleSoundEffects()
        }
       
    }
    
    // MARK: - Game Controller
    
    override func willMove(from view: SKView) {
        teardownControllerObservers()
    }
    
    func setupControllerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidDisconnect), name: .GCControllerDidDisconnect, object: nil)
        if let controller = GCController.controllers().first { setupController(controller) }
    }
    
    func teardownControllerObservers() {
        NotificationCenter.default.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        gameController = nil
    }
    
    @objc func controllerDidConnect(_ notification: Notification) {
        guard gameController == nil, let controller = notification.object as? GCController else { return }
        setupController(controller)
    }
    
    @objc func controllerDidDisconnect(_ notification: Notification) {
        guard let controller = notification.object as? GCController, controller == gameController else { return }
        gameController = nil
    }
    
    func setupController(_ controller: GCController) {
        gameController = controller
        
        let dpadHandler: GCControllerDirectionPadValueChangedHandler = { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            if yValue > 0.5 { self.swipedUp() }
            else if yValue < -0.5 { self.swipedDown() }
        }
        
        let buttonHandler: GCControllerButtonValueChangedHandler = { [weak self] _, _, pressed in
            guard pressed else { return }
            self?.tapped()
        }
        
        if let extended = controller.extendedGamepad {
            extended.dpad.valueChangedHandler = dpadHandler
            extended.leftThumbstick.valueChangedHandler = dpadHandler
            extended.buttonA.valueChangedHandler = buttonHandler
        }
        if let micro = controller.microGamepad {
            micro.dpad.valueChangedHandler = dpadHandler
            micro.buttonA.valueChangedHandler = buttonHandler
        }
    }

 
}
