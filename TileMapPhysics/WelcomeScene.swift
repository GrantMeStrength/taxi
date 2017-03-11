//
//  WelcomeScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/3/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit

import GameplayKit

class WelcomeScene: SKScene {
    
    
    
    // Called when view appears..
    override func didMove(to view: SKView) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        
#if os(tvOS)
     ((view.scene?.childNode(withName: "root")!)! as SKNode).setScale(2.0)
#endif
        
    }
    
    
    
    func tapped(sender: UITapGestureRecognizer)
    {
        let scene = GetReadyScene(fileNamed: "GetReadyScene")!
        let transition = SKTransition.fade(with: UIColor.black, duration: 1)
        self.view?.presentScene(scene, transition: transition)
        
    }
    

}
