//
//  Battery.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 8/31/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//

import SpriteKit

class Battery: NSObject {
    
    
    var active = true
    var sprite: SKSpriteNode?
    var batteryIsTurbo = false
    var turboActive = false
    
    func Setup(Sprite: SKSpriteNode)
    {
        sprite = Sprite
        
        sprite?.physicsBody?.usesPreciseCollisionDetection = true
        sprite?.physicsBody?.categoryBitMask = SpriteCategories.batteryCategory
        sprite?.physicsBody?.contactTestBitMask = SpriteCategories.batteryCategory | SpriteCategories.playerCategory | SpriteCategories.badguyCategory
        sprite?.physicsBody?.collisionBitMask = SpriteCategories.batteryCategory | SpriteCategories.playerCategory | SpriteCategories.badguyCategory
        
    }

    func battery(isHidden : Bool)
    {
        active = !isHidden
        sprite?.isHidden = isHidden
    }
    

    func setPosition(pos: CGPoint)
    {
        sprite?.position = pos
   //     active = true
    }

    func position() -> CGPoint
    {
       return (sprite?.position)!
    }
    
    
    func setType(isTurbo : Bool)
    {
        batteryIsTurbo = isTurbo
        
        if isTurbo
        {
            sprite?.texture =  SKTexture(imageNamed: "turbo")
        }
        else
        {
             sprite?.texture =  SKTexture(imageNamed: "battery")
        }
        
    }

}
