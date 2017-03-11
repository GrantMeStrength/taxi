//
//  GameOverScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/3/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit

import GameplayKit


class GameOverScene: SKScene {
    
    
    var alreadyDoneIt = false
    var score : Int = 0
    
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
            self.tapped(sender: UITapGestureRecognizer(target: self, action: #selector(self.tapped)))
        }
        
        
        
    }
    
    
    
    
    func tapped(sender: UITapGestureRecognizer)
    {
        if !alreadyDoneIt
        {
            alreadyDoneIt = true
            let scene = GetReadyScene(fileNamed: "GetReadyScene")!
            let transition = SKTransition.fade(with: UIColor.black, duration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
       
    }
    
    
}
