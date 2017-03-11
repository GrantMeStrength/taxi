//
//  Passenger.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 8/26/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//



import SpriteKit

class Passenger: NSObject {

    var name = ""
    var type = 1
    var state : PassengerState = .inactive
    var pSprite: SKSpriteNode?
    var dSprite: SKSpriteNode?
    var value = 0
    var px = 0
    var py = 0
    var dx = 0
    var dy = 0
    
    let FREQ : UInt32 = 250 // 400
    
    
    func Update()
    {
        if state == .inactive
        {
            return
        }
        
        if (state == .sleeping)
        {
             let diceRoll = Int(arc4random_uniform(FREQ) + 1)
            
            if (diceRoll == 1)
            {
                state = .hailing
            }
        }
        
    }
    
    func Setup(passengerSprite: SKSpriteNode, dropoffSprite : SKSpriteNode)
    {
        state = .sleeping
        name = randomName()
       // type = Int(arc4random_uniform(3) + 1)
        
        pSprite = passengerSprite
        dSprite = dropoffSprite
        
        pSprite?.physicsBody?.usesPreciseCollisionDetection = true
        pSprite?.physicsBody?.categoryBitMask = SpriteCategories.passengerCategory
        pSprite?.physicsBody?.contactTestBitMask = SpriteCategories.passengerCategory | SpriteCategories.playerCategory | SpriteCategories.badguyCategory
        pSprite?.physicsBody?.collisionBitMask = SpriteCategories.passengerCategory | SpriteCategories.playerCategory | SpriteCategories.badguyCategory
        
        dSprite?.physicsBody?.usesPreciseCollisionDetection = true
        dSprite?.physicsBody?.categoryBitMask = SpriteCategories.passengerDropCategory
        dSprite?.physicsBody?.contactTestBitMask = SpriteCategories.passengerDropCategory | SpriteCategories.playerCategory
        dSprite?.physicsBody?.collisionBitMask = SpriteCategories.passengerDropCategory | SpriteCategories.playerCategory
    }
    
    func passenger(isHidden : Bool)
    {
        pSprite?.isHidden = isHidden
    }
    
    func dropoff(isHidden : Bool)
    {
        dSprite?.isHidden = isHidden
    }
    
    func pickup_position() -> (CGPoint)
    {
        return (pSprite?.position)!
    }
    
    func randomName() -> String
    {
        let r = Int(arc4random_uniform(10) + 1)
        
        switch (r)
        {
        case 1: type = 2; return "Fizzy"
        case 2: type = 2; return "Celeste"
        case 3: type = 2; return "Amelie"
        case 4: type = 1; return "Ross"
        case 5: type = 2; return "Eve"
            
        case 6: type = 1; return "Karl"
        case 7: type = 1; return "Tyler"
        case 8: type = 1; return "Matt"
        case 9: type = 2; return "Kelly"
            
        case 10:type = 3; return "Zombie Pete"
            
        default : return "No-one"
        }
    }

    
    func dropoff_position() -> (CGPoint)
    {
        return (dSprite?.position)!
    }

    func PickLocation( pickup : CGPoint, dropoff : CGPoint)
    {
        // Set pick up and drop off points from a list of known positions
        
     //   print("PickLocation --  pickup/dropoff position at \(pickup, dropoff)")
        
        name = randomName()
        
        px = Int(pickup.x)
        py = Int(pickup.y)
        
        dx = Int(dropoff.x)
        dy = Int(dropoff.y)
        
        HailTaxi() // make sure sprites are matching these co-ords
        
        value = Int (( (px - dx) * (px - dx) + (py - dy) * (py - dy)) / 20000)
 
    }
    
    func getPositionOfPickupRequestBubble () -> CGPoint
    {
        var angle = 0.0
        
        if (state == .driving)
        {
             angle = atan2(Double(dx), Double(dy))
        }
        else
        {
            angle = atan2(Double(px), Double(py))
        }
        
        let apx = cos(angle) * 150
        let apy = sin(angle) * 250
        
        return CGPoint(x: apy, y: apx)
    }
    
    
    func HailTaxi()
    {
        // Show pick-up sprite, hide drop-off
        
        pSprite?.isHidden = false
        pSprite?.position  = CGPoint(x:px,y:py)

        dSprite?.isHidden = true
        dSprite?.position  = CGPoint(x:dx,y:dy)
        
    }
    
    func Hide()
    {
        pSprite?.isHidden = true
        pSprite?.position  = CGPoint(x:-2000,y:-2000)

        
    }
    
    func ShowDropOff()
    {
        // Hide pick-up sprite, show drop-off
        
        dSprite?.isHidden = false
        dSprite?.position  = CGPoint(x:dx,y:dy)
        

    }

    
    func AllOff()
    {
        // Hide pick-up sprite, show drop-off
        
        pSprite?.isHidden = true
        pSprite?.position  = CGPoint(x:-2000,y:-2000)
        
        dSprite?.isHidden = true
        dSprite?.position  = CGPoint(x:-2000,y:-2000)
        


    }

    
}
