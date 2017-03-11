//
//  GameViewController.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 7/9/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//


import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = WelcomeScene(fileNamed: "WelcomeScene") {
                // Set the scale mode to scale to fit the window
               // scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
               
                
                // Process map - done in scene class now
                //scene.processMap();
        
            }
            
            view.ignoresSiblingOrder = true
            
         //   view.showsFPS = true
          //  view.showsNodeCount = true
        }
    }


}
