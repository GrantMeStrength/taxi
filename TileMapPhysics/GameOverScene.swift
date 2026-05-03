//
//  GameOverScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/3/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit

import GameplayKit
import GameController


class GameOverScene: SKScene {
    
    
    var alreadyDoneIt = false
    var score : Int = 0
    var gameController: GCController?
    
    // Called when view appears..
    override func didMove(to view: SKView) {
        
        childNode(withName: "root")?.setScale(2.6)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        
        let label = self.childNode(withName: "root/score") as? SKLabelNode
        
        
        label?.alpha = 0.0
        label?.run(SKAction.fadeIn(withDuration: 1.0))
        
        label?.text = "$\(score)"
        
        let delayTime = DispatchTime.now() + .seconds(10) // After 5 secs go for it.
        
        // Dangerous - need to cancel this if tapped..
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.goToGetReady()
        }
        
        setupControllerObservers()
        
    }
    
    override func willMove(from view: SKView) {
        teardownControllerObservers()
    }
    
    
    
    @objc func tapped(sender: UITapGestureRecognizer)
    {
        goToGetReady()
    }
    
    func goToGetReady() {
        if !alreadyDoneIt
        {
            alreadyDoneIt = true
            let scene = GetReadyScene(fileNamed: "GetReadyScene")!
            let transition = SKTransition.fade(with: UIColor.black, duration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    // MARK: - Game Controller
    
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
        let buttonHandler: GCControllerButtonValueChangedHandler = { [weak self] _, _, pressed in
            guard pressed else { return }
            self?.goToGetReady()
        }
        controller.extendedGamepad?.buttonA.valueChangedHandler = buttonHandler
        controller.microGamepad?.buttonA.valueChangedHandler = buttonHandler
    }
    
}
