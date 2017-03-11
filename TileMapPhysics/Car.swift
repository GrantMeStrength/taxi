//
//  Car.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 8/23/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//


import SpriteKit
import GameplayKit

class Car: NSObject {
    
    struct DirectionAngle
    {
        static let up : CGFloat = CGFloat(M_PI_2)
        static let down : CGFloat = CGFloat(M_PI_2 * 3.0)
        static let left : CGFloat = CGFloat(M_PI)
        static let right : CGFloat = 0
    }
    
    
// carX, carY = SPRITE POSITION.
    // To get to grid position, Int(x - 15)/64
    

    var waitingForNewPath = true
    var stuck = false
    var carX : Int  = 0
    var carY : Int = 0
    var angle : CGFloat = DirectionAngle.up
    var speed = 4
    var currentDirection : Direction = .up
    var nextDirection : Direction = .up
    var previousDirection : Direction = .none
    var sprite : SKSpriteNode?
    var path : Array<(Int, Int)> = []
    var spriteLeft : SKSpriteNode?
    var spriteRight : SKSpriteNode?
    var brakelights : SKSpriteNode?
    var energy  = 1000.0
    var turboTime : TimeInterval = 0.0
    
    func getDirection() -> Direction
    {
        return currentDirection
    }
    
    func forcePosition()
    {
        sprite?.position = CGPoint(x: CGFloat(carX), y: CGFloat(carY))
    }
    

    
    func setSpriteBaddie(carSprite : SKSpriteNode)
    {
        sprite = carSprite
        sprite?.physicsBody?.usesPreciseCollisionDetection = true
        sprite?.physicsBody?.categoryBitMask = SpriteCategories.badguyCategory
        sprite?.physicsBody?.contactTestBitMask = SpriteCategories.playerCategory | SpriteCategories.badguyCategory
        sprite?.physicsBody?.collisionBitMask = SpriteCategories.playerCategory | SpriteCategories.badguyCategory
    }
    
    
    func setSpriteLooper(carSprite : SKSpriteNode)
    {
        sprite = carSprite
        sprite?.physicsBody?.usesPreciseCollisionDetection = true
        sprite?.physicsBody?.categoryBitMask = SpriteCategories.looperCategory
        sprite?.physicsBody?.contactTestBitMask = SpriteCategories.playerCategory | SpriteCategories.looperCategory
        sprite?.physicsBody?.collisionBitMask = SpriteCategories.playerCategory | SpriteCategories.looperCategory
    }
    
    
    
    func setSpritePlayer(carSprite : SKSpriteNode)
    {
        sprite = carSprite
        
        sprite?.physicsBody?.usesPreciseCollisionDetection = true
        sprite?.physicsBody?.categoryBitMask = SpriteCategories.playerCategory
        sprite?.physicsBody?.contactTestBitMask = SpriteCategories.playerCategory | SpriteCategories.badguyCategory | SpriteCategories.looperCategory
        sprite?.physicsBody?.collisionBitMask = SpriteCategories.playerCategory | SpriteCategories.badguyCategory | SpriteCategories.looperCategory
        
        ConnectIndicators()
        
     }
    
    func setPosition(x: Int, y: Int, carangle: CGFloat)
    {
        carX = x;
        carY = y;
        angle = carangle;
        sprite?.position = CGPoint(x: CGFloat(carX), y: CGFloat(carY))
        sprite?.run(SKAction.rotate(toAngle: CGFloat(angle), duration: 0.01))
    }
    
    func position() -> (CGPoint)
    {
        // Wait.. should not return sprite position. Return CarX, CarY

        
        
        return CGPoint(x: carX, y: carY)
      //  return (sprite?.position)!
    }
    
    
    
    func getDirection(car : CGPoint, target: CGPoint) -> Direction
    {
        let carGrid = ConvertSpriteToGrid(pos: car)
        let nodeGrid = ConvertSpriteToGrid(pos: target)
        
        let cx = carGrid.0
        let cy = carGrid.1
        let tx = nodeGrid.0
        let ty = nodeGrid.1
        
        
        if cx == tx && cy == ty
        {
            print("Overlap")
             return .none
        }
        
        
        if cx == tx
        {
            // they are aligned vertically
            
            if cy > ty
            {
                return .down
            }
            
            if (cy < ty)
            {
                return .up
            }
        }
        
        if cy == ty
        {
            // they are aligned horizontally
            
            if cx > tx
            {
                return .left
            }
            
            if (cx < tx)
            {
                return .right
            }
        }

        print("StuckP - \(cx,cy,tx,ty)")
        return .none
    }
    
    /*
    func getDirection(car : (Int, Int), target: (Int, Int)) -> Direction
    {
        
        
        let cx = Int(car.0/1)
        let cy = Int(car.1/1)
        let tx = Int(target.0/1)
        let ty = Int(target.1/1)
        
        if cx == tx
        {
            // they are aligned vertically
            
            if cy > ty
            {
                return .down
            }
            
            if (cy < ty)
            {
                return .up
            }
        }
        
        if cy == ty
        {
            // they are aligned horizontally
            
            if cx > tx
            {
                return .left
            }
            
            if (cx < tx)
            {
                return .right
            }
        }
        
    
        print("StuckI - \(cx,cy,tx,ty)")
        return .none
    }
    */

    
    
    
    func setPath (newPath: Array<(Int, Int)>)
    {
        // remove top one, as we're alread tgere?
        
       if (newPath.isEmpty)
       {
        return
        }
        
         path = newPath
        
        
        
        //Now point the car in the direction of the first item in the path..
        

        let t = path[0]
        
        
        // Use grid positions...
        
        previousDirection = .none
        
        print ("new path contains this first element\(position(), t)")
        
     //   currentDirection = getDirection(car: (currentPosition.0, currentPosition.1), target: t)
        
        currentDirection = getDirection(car: position(), target : CGPoint(x:t.0, y:t.1)) 
        
        
        if (currentDirection == .none)
        {
            
                     return
        }
        
   
        
        
        getSteeringAngleDelta(currentDir: previousDirection, newDir: currentDirection)
        
    
    switch currentDirection
    {
    case .up :  carY += 1;
    case .down : carY -= 1;
    case .left :  carX -= 1;
    case .right : carX += 1;
    case .none : break
    }
    
    sprite?.position = CGPoint(x: CGFloat(carX), y: CGFloat(carY))
    
    
    }

    func ConnectIndicators()
    {
        spriteLeft = sprite?.childNode(withName: "BlinkLeft") as? SKSpriteNode
        spriteRight = sprite?.childNode(withName: "BlinkRight") as? SKSpriteNode
        brakelights = sprite?.childNode(withName: "BrakeLights") as? SKSpriteNode
    }
    
    func StopBlinking()
    {
        spriteLeft?.removeAllActions()
        spriteRight?.removeAllActions()
        
        spriteLeft?.run(SKAction.fadeOut(withDuration: 0.01))
        spriteRight?.run(SKAction.fadeOut(withDuration: 0.01))
    }
    
    func BlinkRight()
    {
        StopBlinking()
        
        spriteRight?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.01),
            SKAction.wait(forDuration: 0.25),
            SKAction.fadeIn(withDuration: 0.01),
            SKAction.wait(forDuration: 0.25)])))
        
    }
    
    func BlinkLeft()
    {
        StopBlinking()
        
        spriteLeft?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.01),
            SKAction.wait(forDuration: 0.25),
            SKAction.fadeIn(withDuration: 0.01),
            SKAction.wait(forDuration: 0.25)])))
    }
    
    
    
    func prepLooper(startingPoint : Int)
    {
        switch (startingPoint)
        {
            
        case 1:
            
            setPosition(x: 640, y: 256-64, carangle:DirectionAngle.up )
            currentDirection = .up
            previousDirection = .up
            
        case 2:
            
            setPosition(x: -640+64, y: 256, carangle:DirectionAngle.left )
            currentDirection = .left
            previousDirection = .left

            
        case 3:
            
            setPosition(x: 640-64, y: -320, carangle:DirectionAngle.right )
            currentDirection = .right
            previousDirection = .right

        case 4:
            
            setPosition(x: -640, y: -320+64, carangle: DirectionAngle.down)
             currentDirection = .down
            previousDirection = .down

        default: break;
            
        }
        
    }
    
    
    func ConvertSpriteToGrid(pos : CGPoint) -> (Int, Int)
    {
        let cx = 15 + (Int(pos.x) / 64)
        let cy = 15 + (Int(pos.y) / 64)
        
        return (cx, cy)
    }
    
    func IsCarAtJunction(pos : CGPoint) -> Bool
    {
        let n = Double(pos.x).truncatingRemainder(dividingBy: 64)
        let m = Double(pos.y).truncatingRemainder(dividingBy: 64)
        
         if (n == 0 && m == 0)
         {
            return true
        }
        else
         {
            return false
        }
        
    }
    
    
    
    func LoopPath( speed : Int)
    {
        let n = Double(carX).truncatingRemainder(dividingBy: 64)
        let m = Double(carY).truncatingRemainder(dividingBy: 64)
        
        if (n == 0 && m == 0)
        {
            
            let cx = 15 + (carX / 64)
            let cy = 15 + (carY / 64)
         
            if cx == 25 && cy == 19  { currentDirection = .left }
            if cx == 5 && cy == 19  { currentDirection = .down }
            if cx == 5  && cy == 10  { currentDirection = .right}
            if cx == 25  && cy == 10  { currentDirection = .up }
            
            if previousDirection != currentDirection
            {
                getSteeringAngleDelta(currentDir: previousDirection, newDir: currentDirection)
                previousDirection = currentDirection
            }
        }
        
        
        switch currentDirection
        {
        case .up :  carY += speed;
        case .down : carY -= speed;
        case .left :  carX -= speed;
        case .right : carX += speed;
        case .none : break
        }
        
        sprite?.position = CGPoint(x: CGFloat(carX), y: CGFloat(carY))
        
        
    }
    

    
    func FollowPath( speed : Int)
    {
        
        if (path.isEmpty)
        {
          //  waitingForNewPath = true
            return
        }
        
        if path.count == 0
        {
         //  waitingForNewPath = true
            return
        }
        
        
        var t = path[0]
  
        
         waitingForNewPath = false
      
        // Car is at next junction point
        
        if (t.0 == carX && t.1 == carY)
        {
             waitingForNewPath = true // Can ONLY be given another path when at a node.
            
            path.remove(at: 0)
            
            if path.count == 0
            {
                return
            }
           
                
            t = path[0]

            previousDirection = currentDirection
            currentDirection = getDirection(car: position(), target : CGPoint(x:t.0, y:t.1))
            
            if (currentDirection == .none)
            {
                print("shit")
               // waitingForNewPath = true
                path.removeAll()    // Start again
        
                return
            }
            
            waitingForNewPath = false
            
            getSteeringAngleDelta(currentDir: previousDirection, newDir: currentDirection)
            
        }
        
            
            switch currentDirection
            {
            case .up :  carY += 1;
            case .down : carY -= 1;
            case .left :  carX -= 1;
            case .right : carX += 1;
            case .none : break
            }
        

            sprite?.position = CGPoint(x: CGFloat(carX), y: CGFloat(carY))
            
        
    }
    
        
        
        func Update(direction : (_: Int, _: Int, _: Int, _: Int) -> Direction, targetX : Int, targetY : Int, speed : Int, test:(_:Int, _:Int)->Bool)
        {
            
            nextDirection = direction(carX, carY,targetX, targetY)
            
            // Check for special 180' flip which was a Human-only skill but why not share it..
            
            // Can swap up/down or left/right at once
            if
                (nextDirection == .up && currentDirection == .down) ||
                    (nextDirection == .down && currentDirection == .up) ||
                    (nextDirection == .left && currentDirection == .right) ||
                    (nextDirection == .right && currentDirection == .left)
                
            {
                previousDirection = currentDirection
                currentDirection = nextDirection
                
                switch nextDirection
                {
                case .up :  angle = DirectionAngle.up
                case .down : angle = DirectionAngle.down
                case .left :  angle = DirectionAngle.left
                case .right : angle = DirectionAngle.right
                case .none : break
                    
                }
                
                sprite?.run(SKAction.rotate(toAngle: CGFloat(angle), duration: 0.15))
                
            }
                
            else
            {
                
                // Are we at a possible turning junction?
                
                let n = Int(Double(carX).truncatingRemainder(dividingBy: 64))
                let m = Int(Double(carY).truncatingRemainder(dividingBy: 64))
                
                
               //print("Junction test: \(n,m)")
            
                if (n == 0 && m == 0)
                {
                    
                    
                    var cx = 15 + (carX / 64)
                    var cy = 15 + (carY / 64)
                    
                    switch nextDirection
                    {
                    case .up :  cy += 1
                    case .down : cy -= 1
                    case .left :  cx -= 1
                    case .right : cx += 1
                    case .none : break
                        
                    }
                    
                    if !test(cx, cy)
                    {
                        // Yes, we can move in the nextDirection
                        
                        if nextDirection != currentDirection
                        {
                            // Test Starting from scratch again after stopping
                            if currentDirection == .none
                            {
                                getSteeringAngleDelta(currentDir: previousDirection, newDir: nextDirection)
                            }
                            else
                            {
                                getSteeringAngleDelta(currentDir: currentDirection, newDir: nextDirection)
                            }
                            
                            currentDirection = nextDirection
                        }
                    }
                    else
                    {
                        // Can we carry on moving in the current direction?
                        
                        cx = 15 + (carX / 64)
                        cy = 15 + (carY / 64)
                        
                        switch currentDirection
                        {
                        case .up :  cy += 1
                        case .down : cy -= 1
                        case .left :  cx -= 1
                        case .right : cx += 1
                        case .none : break
                            
                        }
                        
                        if !test(cx, cy)
                        {
                            // Carry on, it's clear
                        }
                        else
                        {
                            // Stop - only the users car uses this remember. Flash brake lights?
                            
                            brakelights?.alpha = 1
                            brakelights?.run(SKAction.fadeOut(withDuration: 0.5))
                            previousDirection = currentDirection
                            currentDirection = .none
                            nextDirection = .none
                        }
                        
                    }
                    
                }
                
                
            }
            
            
            // Update the position
            switch currentDirection
            {
            case .up :  carY += 1;
            case .down : carY -= 1;
            case .left :  carX -= 1;
            case .right : carX += 1;
            case .none : break
            }
            

            
            sprite?.position = CGPoint(x: CGFloat(carX), y: CGFloat(carY))
            
        }
        
        
        func randomDirection() -> Direction
        {
            let diceRoll = Int(arc4random_uniform(4) + 1)
 
            switch (diceRoll)
            {
            case 1: return .up
            case 2: return .down
            case 3: return .left
            case 4: return .right
            default: return .none
            }
        }
        
        func getSteeringAngleDelta(currentDir : Direction, newDir: Direction)
        {
            let dur = 0.2
            
            if currentDir == newDir {
                return
            }
            
            if newDir == .up
            {
                sprite?.run(SKAction.rotate(toAngle: DirectionAngle.up, duration: dur, shortestUnitArc: true))
            }
            
            if (newDir == .down)
            {
                sprite?.run(SKAction.rotate(toAngle: DirectionAngle.down, duration: dur, shortestUnitArc: true))
            }
            
            if (newDir == .left)
            {
                sprite?.run(SKAction.rotate(toAngle: DirectionAngle.left, duration: dur, shortestUnitArc: true))
            }
            
            if (newDir == .right)
            {
                 sprite?.run(SKAction.rotate(toAngle: DirectionAngle.right, duration: dur, shortestUnitArc: true))
            }
            
    }
        
}
