//
//  GameOverScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/3/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit

import GameplayKit


class LevelCompleteScene: SKScene {

    var alreadyDoneIt = false
    var score : Int = 0
    var level : Int = 0
    
    // Called when view appears..
    override func didMove(to view: SKView) {
        
        level += 1
        
        if level > 12 { level = 12 }
        
        
        Settings().SaveLevel(level: level)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        
        let label = self.childNode(withName: "score") as? SKLabelNode
        
       
            label?.alpha = 0.0
            label?.run(SKAction.fadeIn(withDuration: 1.0))
        
        label?.text = "$\(score)"
        
        
        
        let delayTime = DispatchTime.now() + .seconds(10) // After 5 secs go for it.
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.tapped(sender: UITapGestureRecognizer(target: self, action: #selector(self.tapped)))
        }
        
        
        
    }
    
    
    
    
    func tapped(sender: UITapGestureRecognizer)
    {
        if alreadyDoneIt == false
        {
            alreadyDoneIt = true
        
        let scene = GetReadyScene(fileNamed: "GetReadyScene")!
        let transition = SKTransition.fade(with: UIColor.black, duration: 1)
        self.view?.presentScene(scene, transition: transition)
        }
    }
    
    
}
