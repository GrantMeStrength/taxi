//
//  GameScene.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 7/9/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit


struct SpriteCategories
{
    static let playerCategory : UInt32 = 0x1 << 0
    static let badguyCategory : UInt32 = 0x1 << 1
    static let passengerCategory : UInt32 = 0x1 << 2
    static let passengerDropCategory : UInt32 = 0x1 << 3
    static let batteryCategory : UInt32 = 0x1 << 4
    static let looperCategory : UInt32 = 0x1 << 5
    static let lightningCategory : UInt32 = 0x1 << 6
}

enum Direction {
    case none
    case up
    case right
    case down
    case left
}


enum SFX {
    case Explode
    case GameStart
    case Turbo
    case PowerUp
    case PickUpRequest
    case PickUp
    case DropOff
    case Tap
}

enum MUSICSFX {
    case Stop
    case FunkyBeats
    case FunkyBeatsFaster
    case BonusBeats
}

enum PassengerState {
    case inactive   // Not being used in this round
    case sleeping   // waiting to decide to appear and hail a ride
    case hailing    // one-off trigger hailing action
    case waiting    // waiting to be picked up
    case driving    // picked up, waiting to be dropped off
}


enum GameState : String {
    case starting
    case pre_playing
    case playing
    case badcarcontact
    case exploding
    case outofenergy1
    case outofenergy2
    case gameover
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let sounds = SoundEffects()
    var settings = Settings()
    
    var NUMBER_OF_BADDIES =  1
    var NUMBER_OF_LOOPERS = 4
    var NUMBER_OF_PASSENGERS = 2
    var currentGameTime : TimeInterval = 0
    
    var exploding = false
    var carHasBeenEmpty = true
    var personInCar = 0
    
    
    
    var labelTalk1 : SKLabelNode?
    var labelTalk2 : SKLabelNode?
    var labelScore : SKLabelNode?
    var labelTarget : SKLabelNode?
    var labelBonus : SKLabelNode?
    
    // Passengers
    
    var passengerSprite1 : SKSpriteNode?
    var passengerSprite2 : SKSpriteNode?
    var passengerSprite3 : SKSpriteNode?
    
    var labelPassengerInformation   : SKLabelNode?
    var passengerName : SKLabelNode?
    var passengerInformationNode : SKNode?
    var EnergyNode : SKNode?
    
    var sky : SKTileMapNode?
    var gameCamera : SKCameraNode?
    
    var tileSet : SKTileSet?
    var tileMap : SKTileMapNode?
    var radarNode : SKSpriteNode?
    var energyBar : SKSpriteNode?
    var underEnergyBar : SKSpriteNode?
    
    var roadGraph : GKGridGraph<GKGridGraphNode>?
    
    
    // Cars & stuff
    var GoodGuy = Car()
    var BadGuys = [Car]()
    var LoopGuys = [Car]()
    var power = Battery()
    var people = [Passenger]()
    var HeadlightsMask : SKSpriteNode?
    var lightning : SKSpriteNode?
    var labelLightning : SKLabelNode?
    var lightningActive = false
    var lightningCount = 3
    var lightningTime : TimeInterval = 0
    var carsStalled = false
    
    // Radar
    var bad_blobs = [SKSpriteNode]()
    var looper_blobs = [SKSpriteNode]()
    var blob_player : SKSpriteNode?
    var blob_power : SKSpriteNode?
    var people_pickup_blobs = [SKSpriteNode]()
    var people_dropoff_blobs = [SKSpriteNode]()
    
    // State
    
    var pause = false
    var messageBusy = false  // don't show a new message if this is true.
    var gameLevel = 1
    var bonusLevel = false
    var gameTarget = 100
    var currentGameState = GameState.starting
    var gametime : TimeInterval = 0
    var score = 0
    var lightningLimit = 7.0
    
    var width : CGFloat = 0
    var height : CGFloat = 0
    
    #if os(tvOS)
    var menuView : MenuBottonView!
    #endif
    
    func DefineLevel()
    {
        
        // Given gameLevel, set the number of baddies etc.
        
        //  gameLevel = 13
        
        if (gameLevel==1)
        {
            NUMBER_OF_PASSENGERS = 1
            NUMBER_OF_LOOPERS = 0
            NUMBER_OF_BADDIES = 3
            gameTarget = 200
        }
        
        if (gameLevel==2)
        {
            NUMBER_OF_PASSENGERS = 1
            NUMBER_OF_LOOPERS = 0
            NUMBER_OF_BADDIES = 4
            gameTarget = 250
        }
        
        
        if (gameLevel==3)
        {
            NUMBER_OF_PASSENGERS = 1
            NUMBER_OF_LOOPERS = 1
            NUMBER_OF_BADDIES = 3
            gameTarget = 300
        }
        
        
        if (gameLevel==4)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 1
            NUMBER_OF_BADDIES = 4
            gameTarget = 350
        }
        
        
        if (gameLevel==5)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 2
            NUMBER_OF_BADDIES = 4
            gameTarget = 400
        }
        
        if (gameLevel==6)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 3
            NUMBER_OF_BADDIES = 5
            gameTarget = 450
        }
        
        if (gameLevel==7)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 4
            NUMBER_OF_BADDIES = 6
            gameTarget = 500
        }
        
        if (gameLevel==8)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 4
            NUMBER_OF_BADDIES = 7
            gameTarget = 550
        }
        
        if (gameLevel==9)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 4
            NUMBER_OF_BADDIES = 8
            gameTarget = 600
        }
        
        if (gameLevel==10)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 4
            NUMBER_OF_BADDIES = 9
            gameTarget = 600
        }
        
        if (gameLevel==11)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 4
            NUMBER_OF_BADDIES = 10
            gameTarget = 600
        }
        
        if (gameLevel==12)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 4
            NUMBER_OF_BADDIES = 10
            gameTarget = 700
        }
        
        if (gameLevel==13)
        {
            NUMBER_OF_PASSENGERS = 2
            NUMBER_OF_LOOPERS = 0
            NUMBER_OF_BADDIES = 1
            gameTarget = 2000
        }
        
        
        if bonusLevel
        {
            NUMBER_OF_PASSENGERS = 0
        }
        
    }
    
    // Called when view appears..
    override func didMove(to view: SKView) {
        
        
        _ = settings.Load()
        
        
        
        // Get label node from scene and store it for use later
        labelTalk1 = self.childNode(withName: "//talkLabel1") as? SKLabelNode
        labelTalk2 = self.childNode(withName: "//talkLabel2") as? SKLabelNode
        passengerName = self.childNode(withName: "//passengerName") as? SKLabelNode
        
        
        tileMap = childNode(withName: "TileMapNode") as? SKTileMapNode
        
        
        // For path finding
        createGraph()
        
        
        // For interacting with landscape
        //    processMap();
        
        // Set the number of various things
        DefineLevel()
        
        
        // Connect sprites
        gameCamera = childNode(withName: "Camera") as? SKCameraNode
        sky = childNode(withName : "TileMapNodeRoads") as? SKTileMapNode
        
        // Power
        
        energyBar = gameCamera?.childNode(withName: "//powerBar") as? SKSpriteNode
        underEnergyBar = gameCamera?.childNode(withName: "//underpowerBar") as? SKSpriteNode
        EnergyNode = (gameCamera?.childNode(withName: "EnergyNode"))! as SKNode
        
        
        // Passenger stuff
        
        labelPassengerInformation =  gameCamera?.childNode(withName: "//labelPassengerInformation") as? SKLabelNode
        passengerInformationNode =  (gameCamera?.childNode(withName: "passengerInformationNode"))! as SKNode
        passengerInformationNode?.alpha = 0
        passengerSprite1 = gameCamera?.childNode(withName: "//passengerSprite1") as? SKSpriteNode
        passengerSprite2 = gameCamera?.childNode(withName: "//passengerSprite2") as? SKSpriteNode
        passengerSprite3 = gameCamera?.childNode(withName: "//passengerSprite3") as? SKSpriteNode
        
        
        // Radar
        
        radarNode = gameCamera?.childNode(withName: "Radar") as? SKSpriteNode
        
        blob_player = SKSpriteNode(color:.yellow,size:CGSize(width: 7, height : 7))
        blob_power = SKSpriteNode(color:.orange,size:CGSize(width: 5, height : 5))
        
        blob_power?.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 0.50),SKAction.wait(forDuration: 0.20),SKAction.fadeOut(withDuration: 0.5),SKAction.wait(forDuration: 0.25) ])))
        
        
        radarNode?.addChild(blob_player!)
        radarNode?.addChild(blob_power!)
        
        blob_player?.zPosition = 31
        blob_power?.zPosition = 30
        
        
        for i in 1...NUMBER_OF_BADDIES
        {
            let bad = Car()
            bad.setSpriteBaddie(carSprite: (childNode(withName: "Bad\(i)") as? SKSpriteNode)!)
            BadGuys.append(bad)
            
            let badblob = SKSpriteNode(color:.red,size:CGSize(width: 5, height : 5))
            radarNode?.addChild(badblob)
            badblob.zPosition = 30
            bad_blobs.append(badblob)
        }
        
        
        for i in 0..<NUMBER_OF_LOOPERS
        {
            let looper = Car()
            looper.setSpriteLooper(carSprite: (childNode(withName: "Looper\(i+1)") as? SKSpriteNode)!)
            looper.prepLooper(startingPoint: i+1)
            LoopGuys.append(looper)
            
            
            
            let looperblog = SKSpriteNode(color:.gray,size:CGSize(width: 5, height : 5))
            radarNode?.addChild(looperblog)
            looperblog.zPosition = 30
            looper_blobs.append(looperblog)
        }
        
        
        if NUMBER_OF_PASSENGERS > 0
        {
            for i in 1...NUMBER_OF_PASSENGERS
            {
                let person = Passenger()
                person.Setup(passengerSprite: (childNode(withName: "Passenger\(i)") as? SKSpriteNode)!, dropoffSprite: (childNode(withName: "PassengerDrop\(i)") as? SKSpriteNode!)!)
                people.append(person)
                
                let pBlob = SKSpriteNode(color:.green,size:CGSize(width: 5, height : 5))
                radarNode?.addChild(pBlob)
                pBlob.zPosition = 30
                people_pickup_blobs.append(pBlob)
                
                let dBlob = SKSpriteNode(color:.white,size:CGSize(width: 4, height : 4))
                radarNode?.addChild(dBlob)
                dBlob.zPosition = 30
                people_dropoff_blobs.append(dBlob)
                
                
                let fadeIn = SKAction.fadeIn(withDuration: 0.25)
                let pause = SKAction.wait(forDuration: 0.25)
                let fadeOut = SKAction.fadeOut(withDuration: 0.25)
                
                let Sequence = SKAction.sequence([fadeIn, pause, fadeOut,pause])
                
                pBlob.run(SKAction.repeatForever(Sequence))
                dBlob.run(SKAction.repeatForever(Sequence))
            }
        }
        
        
        GoodGuy.setSpritePlayer(carSprite: (childNode(withName: "Wheel") as? SKSpriteNode)!)
        GoodGuy.setPosition(x: 0, y: 0, carangle: CGFloat(M_PI_2))
        
        // Headlights
        HeadlightsMask =  GoodGuy.sprite?.childNode(withName: "headlightsMask") as? SKSpriteNode
        HeadlightsMask?.isHidden = true  // Night-time mode on/off.
        
        
        
        labelScore = gameCamera?.childNode(withName: "labelScore") as? SKLabelNode
        labelTarget = labelScore?.childNode(withName: "labelTarget") as? SKLabelNode
        
        
        // Lighting
        
        lightning = self.childNode(withName: "lightning") as? SKSpriteNode
        labelLightning = labelScore?.childNode(withName: "labelLightning") as? SKLabelNode
        lightning?.physicsBody?.usesPreciseCollisionDetection = true
        lightning?.physicsBody?.categoryBitMask = SpriteCategories.lightningCategory
        lightning?.physicsBody?.contactTestBitMask = SpriteCategories.lightningCategory | SpriteCategories.badguyCategory | SpriteCategories.looperCategory
        lightning?.physicsBody?.collisionBitMask = SpriteCategories.lightningCategory | SpriteCategories.badguyCategory | SpriteCategories.looperCategory
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        // Debug view of outlines
        // view.showsPhysics = true
        
        
        labelBonus = gameCamera?.childNode(withName: "labelBonus") as? SKLabelNode
        
        tileSet = tileMap?.tileSet
        gameCamera?.setScale(0.1)
        power.Setup(Sprite: (childNode(withName: "Battery") as? SKSpriteNode)!)
        self.physicsWorld.contactDelegate = self
        ZoomIn()
        addSwipe()
        
        
        
        

        
        // Get screen size and move elements into position
        width = (self.view?.frame.width)!
        height = (self.view?.frame.height)!


#if os(tvOS)
    // Scale up details and tweak screen size to fake new position
passengerInformationNode?.setScale(2.0)
EnergyNode?.setScale(2.0)
labelScore?.setScale(2.0)
radarNode?.setScale(2.0)
    width = 1780
    height = 940
    
   #endif
    
    
        passengerInformationNode?.position = CGPoint(x:  -(width/2.0)+68, y: -(height/2.0) + 77)
        labelScore?.position = CGPoint(x: -(width/2.0) + 48, y: (height/2.0)-32)
        radarNode?.position = CGPoint(x:(width/2) - 68,y: -(height/2.0) + 68)
        EnergyNode?.position = CGPoint(x:(width/2) - 68,y: (height/2.0)-32)
        
        
        let tapRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.tv_remote_pause))
        tapRecognizer1.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)];
        self.view?.addGestureRecognizer(tapRecognizer1)
        
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tv_remote_menu))
        tapRecognizer2.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)];
        self.view?.addGestureRecognizer(tapRecognizer2)
        
        // The pause menu that appears on a SubView
    #if os(tvOS)
        menuView = Bundle.main.loadNibNamed("MenuBottonView", owner: self, options: nil)?[0] as? MenuBottonView
        
        
        view.addSubview(menuView);
        
        let PlayButton = menuView.viewWithTag(1) as! UIButton
        let QuitButton = menuView.viewWithTag(2) as! UIButton
        PlayButton.addTarget(self, action: #selector(GameScene.tapPlay(_:)), for: UIControlEvents.primaryActionTriggered)
        QuitButton.addTarget(self, action: #selector(GameScene.tapQuit(_:)), for: UIControlEvents.primaryActionTriggered)
        
        menuView.AskForFocus()
        menuView.isHidden = true
        #endif
    }
    
    func tapPlay(_ sender:UIButton!)
    {
         scene?.isPaused = false
        // Unpause game and continue
           #if os(tvOS)
        menuView.isHidden = true
            #endif
        
        pause = false
        sounds.playMusic(track: MUSICSFX.BonusBeats)
    }
    
    func tapQuit(_ sender:UIButton!)
    {
        
        // Quit game
      pause = false
           #if os(tvOS)
        menuView.isHidden = true
            #endif
        
        sounds.stopMusic()
        let scene = GameOverScene(fileNamed: "GameOverScene")!
        scene.score = score
        let transition = SKTransition.doorway(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)

      
        
    }
    
    func tv_remote_pause(sender : UITapGestureRecognizer) {
        
        // pause the game
        pause = !pause
        
        if pause
        {
             sounds.stopMusic()
            self.view?.alpha = 0.5
             scene?.isPaused = true
        }
        else
        {
            self.view?.alpha = 1.0
             scene?.isPaused = false
            sounds.playMusic(track: MUSICSFX.BonusBeats)
        }
        
    }
    
    func tv_remote_menu(sender : UITapGestureRecognizer) {
        self.view?.alpha = 1.0
         sounds.stopMusic()
        pause = true
           #if os(tvOS)
        menuView.isHidden = false
            menuView.AskForFocus();
            #endif
        
            scene?.isPaused = true
    }
    
    
    
    func tapped(sender: UITapGestureRecognizer)
    {
        
        
        if lightningActive || lightningCount == 0
        {
            return
        }
        
        // Blink screen
        
        
        lightning?.removeAllActions()
        
        if settings.AudioEffects!
        {
            lightning?.run(sounds.bonus3)
        }
        
        let fadeIn = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.05)
        let fadeOut = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.05)
        
        let zoomIn = SKAction.resize(toWidth: 32, height: 32, duration: 1)
        let Sequence = SKAction.sequence([fadeIn,fadeOut])
        
        
        lightning?.run(SKAction.repeatForever(Sequence))
        
        
        
        lightning?.run(zoomIn)
        
        
        
        // make lighting appear
        
        lightningCount -= 1
        labelLightning?.text = String("x\(lightningCount)")
        lightningTime = 0
        lightning?.position = GoodGuy.position()
        lightning?.isHidden = false
        lightningActive = true
        
        lightningLimit = 7
        
        
        /*
         
         
         if (gameCamera?.xScale)! < CGFloat(1.5)
         {
         gameCamera?.setScale(3.5)
         }
         else
         {
         gameCamera?.setScale(1.4)
         }
         */
        
    }
    
    
    func FlashGoodGuy(flash : Bool)
    {
        let fadeIn = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.05)
        let fadeOut = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.05)
        let Sequence = SKAction.sequence([fadeIn,fadeOut])
        
        if flash
        {
            GoodGuy.sprite?.run(SKAction.repeatForever(Sequence))
        }
        else
        {
            GoodGuy.sprite?.removeAllActions()
            GoodGuy.sprite?.run(fadeOut)
        }
    }
    
    func FlashAllCars (flash : Bool)
    {
        
        let fadeIn = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.05)
        let fadeOut = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.05)
        let Sequence = SKAction.sequence([fadeIn,fadeOut])
        
        for bad in BadGuys
        {
            if flash
            {
                bad.sprite?.run(SKAction.repeatForever(Sequence))
            }
            else
            {
                bad.sprite?.removeAllActions()
                bad.sprite?.run(fadeOut)
            }
        }
        
        
        for looper in LoopGuys
        {
            
            if flash
            {
                looper.sprite?.run(SKAction.repeatForever(Sequence))
            }
            else
            {
                looper.sprite?.removeAllActions()
                looper.sprite?.run(fadeOut)
            }
            
            
        }
        
        
    }
    
    
    func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action:#selector(handleSwipe))
            gesture.direction = direction
            self.view?.addGestureRecognizer(gesture)
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        
        switch (sender.direction)
        {
        case UISwipeGestureRecognizerDirection.right :  GoodGuy.nextDirection = .right
        case UISwipeGestureRecognizerDirection.left :  GoodGuy.nextDirection = .left
        case UISwipeGestureRecognizerDirection.up :  GoodGuy.nextDirection = .up
        case UISwipeGestureRecognizerDirection.down :  GoodGuy.nextDirection = .down
        default: break;
            
        }
        
        
        if (GoodGuy.currentDirection == .up && GoodGuy.nextDirection == .right)
            || (GoodGuy.currentDirection == .right && GoodGuy.nextDirection == .down)
            || (GoodGuy.currentDirection == .down && GoodGuy.nextDirection == .left)
            || (GoodGuy.currentDirection == .left && GoodGuy.nextDirection == .up)
        {
            GoodGuy.BlinkRight()
        }
        
        if (GoodGuy.currentDirection == .up && GoodGuy.nextDirection == .left)
            || (GoodGuy.currentDirection == .left && GoodGuy.nextDirection == .down)
            || (GoodGuy.currentDirection == .down && GoodGuy.nextDirection == .right)
            || (GoodGuy.currentDirection == .right && GoodGuy.nextDirection == .up)
        {
            GoodGuy.BlinkLeft()
        }
        
    }
    
    
    
    
    func UpdatePassenger()
    {
        if bonusLevel
        {
            return
        }
        
        for person in people
        {
            
            person.Update()
            
            if (person.state == .hailing && messageBusy == false)
            {
                
                let pickup = RandomLocation()
                let dropoff = RandomLocation()
                
                // Activate the person, set up the evil cars to follow that person
                person.PickLocation(pickup: pickup, dropoff: dropoff)
                HailAction(person: person)
                person.state = .waiting // Now waiting to be picked up
                
                
                for bad in BadGuys
                {
                    
                    PickANewPathForCar(bad: bad, person: person)
                    
                }
            }
        }
    }
    
    
    
    func ScaleRadar(position: CGPoint) -> CGPoint
    {
        var x = position.x
        var y = position.y
        x=x/16
        y=y/16
        return CGPoint(x: x, y: y)
    }
    
    
    func UpdateRadar()
    {
        blob_player?.position = ScaleRadar(position: GoodGuy.position())
        blob_power?.position = ScaleRadar(position: power.position())
        blob_power?.isHidden = !power.active
        
        if power.active
        {
            blob_power?.isHidden = false
        }
        else
        {
            blob_power?.isHidden = true
        }
        
        
        for i in 0..<NUMBER_OF_PASSENGERS
        {
            
            if (people[i].state == .waiting)
            {
                let p = people[i].pickup_position()
                people_pickup_blobs[i].position = ScaleRadar(position: p)
                people_pickup_blobs[i].isHidden = false
            }
            else
            {
                people_pickup_blobs[i].isHidden = true
            }
            
            if (people[i].state == .driving)
            {
                people_dropoff_blobs[i].isHidden = false
                let d = people[i].dropoff_position()
                people_dropoff_blobs[i].position = ScaleRadar(position: d)
            }
            else
            {
                people_dropoff_blobs[i].isHidden = true
            }
            
        }
        
        
        for i in 0..<NUMBER_OF_BADDIES
        {
            let p = BadGuys[i].position()
            bad_blobs[i].position = ScaleRadar(position: p)
        }
        
        
        for i in 0..<NUMBER_OF_LOOPERS
        {
            let p = LoopGuys[i].position()
            looper_blobs[i].position = ScaleRadar(position: p)
        }
        
    }
    
    
    func GetCompassDirection(position : CGPoint) -> String
    {
        
        if position.y < -450
        {
            
            if (position.x < -450) {return "South West"}
            if (position.x < 450) {return "South"}
            return "South East"
        }
        
        if position.y < 450
        {
            
            if (position.x < -450) {return "West"}
            if (position.x < 450) {return "Central District"}
            return "East"
        }
        
        if (position.x < -450) {return "North West"}
        if (position.x < 450) {return "North"}
        return "North East"
        
    }
    
    
    func PanToDropoff(person : Passenger)
    {
        
        // The passenger has just been picked up, so move to the dropoff, and add a speech bubble and hide the person and show the drop off.
        // Make the announcement bubble appear in the correct direction, and then vanish
        
        passengerInformationNode?.isHidden = false
        passengerInformationNode?.alpha = 0
        
        labelPassengerInformation?.text = "Thanks, drop me in the \(GetCompassDirection(position: person.dropoff_position()))!"
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        
        let Sequence = SKAction.sequence([fadeIn, pause, fadeOut])
        
        passengerInformationNode?.run(Sequence)
        
    }
    
    
    
    func updatePassengerSprite(type : Int)
    {
        switch (type)
        {
        case 1: passengerSprite1?.alpha = 1; passengerSprite2?.alpha = 0; passengerSprite3?.alpha = 0;
        case 2: passengerSprite1?.alpha = 0; passengerSprite2?.alpha = 1; passengerSprite3?.alpha = 0;
        case 3: passengerSprite1?.alpha = 0; passengerSprite2?.alpha = 0; passengerSprite3?.alpha = 1;
        default: break
        }
    }
    
    func HailAction(person : Passenger)
    {
        
        // The passenger has just appeared.
        // Make the announcement bubble appear in the correct direction, and then vanish
        
        messageBusy = true
        
        passengerInformationNode?.isHidden = false
        passengerInformationNode?.alpha = 0
        
        if settings.AudioEffects!
        {
            passengerInformationNode?.run(sounds.chime)
        }
        
        labelPassengerInformation?.text = "I need a ride! I'm \(GetCompassDirection(position: person.pickup_position()))"
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let rb = SKAction.run({ self.messageBusy = false;})
        let Sequence = SKAction.sequence([fadeIn, pause, fadeOut, rb])
        
        passengerInformationNode?.run(Sequence)
        
        updatePassengerSprite(type: person.type)
        passengerName?.text = person.name
        
        
    }
    
    
    func TooSlow(person : Passenger)
    {
        messageBusy = true
        
        if settings.AudioEffects!
        {
            passengerInformationNode?.run(sounds.chime)
        }
        
        passengerInformationNode?.isHidden = false
        passengerInformationNode?.alpha = 0
        updatePassengerSprite(type: person.type)
        passengerName?.text = person.name
        labelPassengerInformation?.text = "Too slow - I got another ride!"
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let rb = SKAction.run({ self.messageBusy = false})
        
        let Sequence = SKAction.sequence([fadeIn, pause, fadeOut, rb])
        
        passengerInformationNode?.run(Sequence)
        
        
    }
    
    
    func GoodDropoff(person : Passenger)
    {
        if settings.AudioEffects!
        {
            passengerInformationNode?.run(sounds.chime)
        }
        
        passengerInformationNode?.isHidden = false
        passengerInformationNode?.alpha = 0
        passengerName?.text = person.name
        updatePassengerSprite(type: person.type)
        labelPassengerInformation?.text = "Thank you! Fare: $\(person.value)"
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let pause = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let rb = SKAction.run({ self.messageBusy = false})
        
        let Sequence = SKAction.sequence([fadeIn, pause, fadeOut,rb])
        
        passengerInformationNode?.run(Sequence)
    }
    
    
    
    func FindPersonFromSprite(sprite : SKSpriteNode) -> Passenger?
    {
        
        for p in people
        {
            if p.pSprite == sprite
            {
                return p
            }
        }
        return nil
        
    }
    
    func FindPersonFromDropoffSprite(sprite : SKSpriteNode) -> Passenger?
    {
        
        for p in people
        {
            if p.dSprite == sprite
            {
                return p
            }
        }
        return nil
        
    }
    
    
    
    func ZoomIn()
    {
        #if os(tvOS)
            gameCamera?.run(SKAction.scale(to: 0.6, duration: 1.5))
        #else
            gameCamera?.run(SKAction.scale(to: 1.4, duration: 1.5))
            
        #endif
    }
    
    func ZoomOut()
    {
        #if os(tvOS)
            gameCamera?.run(SKAction.scale(to: 0.5, duration: 1.5))
        #else
            gameCamera?.run(SKAction.scale(to: 0.2, duration: 1.5))
        #endif
    }
    
    
    func collide(firstNode : SKSpriteNode, secondNode : SKSpriteNode, firstSpriteBitMask : UInt32, secondSpriteBitMask : UInt32) -> Bool
    {
        if (firstNode.physicsBody!.categoryBitMask == firstSpriteBitMask
            &&
            secondNode.physicsBody!.categoryBitMask == secondSpriteBitMask)
            ||
            
            (firstNode.physicsBody!.categoryBitMask == secondSpriteBitMask
                &&
                secondNode.physicsBody!.categoryBitMask == firstSpriteBitMask)
            
        {
            return true
        }
        return false
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        
        
        let firstNode = contact.bodyA.node as! SKSpriteNode
        let secondNode = contact.bodyB.node as! SKSpriteNode
        
        
        
        if gameLevel != 13
        {
            
            // Player and Badbuy
            if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.playerCategory, secondSpriteBitMask: SpriteCategories.badguyCategory))
            {
                
                if (currentGameState != .exploding)
                {
                    currentGameState = .badcarcontact
                    
                    firstNode.physicsBody?.allowsRotation = true
                    secondNode.physicsBody?.allowsRotation = true
                    firstNode.physicsBody?.pinned = false
                    secondNode.physicsBody?.pinned = false
                    firstNode.physicsBody?.applyForce(CGVector(dx: 5000, dy: 100))
                    secondNode.physicsBody?.applyForce(CGVector(dx: -5000, dy: 100))
                    
                }
                
                return
            }
        }
        
        // Badguy and lightning
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.lightningCategory, secondSpriteBitMask: SpriteCategories.badguyCategory)
            ||
            collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.lightningCategory, secondSpriteBitMask: SpriteCategories.looperCategory)
            )
        {
            
            if (lightningActive)
            {
                carsStalled = true
                
                lightning?.removeAllActions()
                
                let zoomIn = SKAction.resize(toWidth: 1, height: 1, duration: 0.05)
                let zoomOut = SKAction.resize(toWidth: 32, height: 32, duration: 0.05)
                let Sequence = SKAction.sequence([zoomIn,zoomOut ])
                
                lightning?.run(SKAction.repeatForever(Sequence))
                
                if settings.AudioEffects!
                {
                    power.sprite?.run(sounds.lightning)
                }
                
                FlashAllCars(flash: true)
                
                // keep cars stunned for bit longer time
                lightningLimit = 9
                
            }
            
            return
        }
        
        
        
        
        // player and looper
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.playerCategory, secondSpriteBitMask: SpriteCategories.looperCategory))
        {
            
            
            if (currentGameState != .exploding)
            {
                currentGameState = .badcarcontact
            }
            
            return
        }
        
        
        
        // Player got to pick up the passenger
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.playerCategory, secondSpriteBitMask: SpriteCategories.passengerCategory))
        {
            
            // Begin the picking up process
            
            
            
            
            let p = FindPersonFromSprite(sprite: secondNode)
            
            
            if (p?.state == .waiting)
            {
                print("Looking for person you hit")
                
                var pickedAll = true
                
                p?.state = .driving
                
                personInCar += 1
                
                for pp in people
                {
                    if pp.state != .driving
                    {
                        
                        pickedAll = false
                    }
                    
                }
                
                
                if pickedAll && NUMBER_OF_PASSENGERS > 1 && carHasBeenEmpty
                {
                    MessageRise(message: "Multiple Pickup Bonus!", position: CGPoint(x: 0, y: 20))
                    score += 50
                    if settings.AudioEffects!
                    {
                        self.run(sounds.kaching)
                    }
                    carHasBeenEmpty = false // Cannot get this bonus again until the car has Zero people in it, or level restart.
                }
                else
                {
                    MessageRise(message: "Pickup!", position: CGPoint(x: 0, y: 20))
                    score += 10
                    if settings.AudioEffects!
                    {
                        self.run(sounds.kaching)
                    }
                }
                
                updateScore()
                
                
                p?.Hide()
                p?.ShowDropOff()
                
                PanToDropoff(person: p!)
                
            }
            // else
            //  {
            // print("Pick up fail >")
            // print(p?.name)
            // print(p?.state)
            // print("< Pick up fail")
            
            //  }
            
            
        }
        
        
        // Bad bug does pickup first
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.badguyCategory, secondSpriteBitMask: SpriteCategories.passengerCategory))
        {
            // badguy got passenger
            
            
            let p = FindPersonFromSprite(sprite: secondNode)
            if (p?.state == .waiting)
            {
                TooSlow(person: p!)
                print("2 Bad guy got her first")
                p?.state = .sleeping
                p?.Hide()
            }
            
        }
        
        
        
        
        
        // Player at drop off point
        
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.playerCategory, secondSpriteBitMask: SpriteCategories.passengerDropCategory))
        {
            
            let p = FindPersonFromDropoffSprite(sprite: secondNode)
            
            if (p == nil)
            {
                print("Bummer.. \(firstNode, secondNode)")
            }
            
            if (p?.state == .driving)
            {
                GoodDropoff(person: p!)
                p?.state = .sleeping
                p?.AllOff()
                score += (p?.value)!
                updateScore()
                if settings.AudioEffects!
                {
                    self.run(sounds.kaching)
                }
                personInCar -= 1
                
                if personInCar == 0
                {
                    carHasBeenEmpty = true
                }
                
                
                
            }
        }
        
        
        
        // Battery  picked up by player
        
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.playerCategory, secondSpriteBitMask: SpriteCategories.batteryCategory))
        {
            if (power.active)
            {
                
                power.active = false
                
                if bonusLevel
                {
                    batteriesCollected += 1
                    MessageRise(message: "Got it!", position: CGPoint(x: 0, y: 20))
                    if settings.AudioEffects!
                    {
                        power.sprite?.run(sounds.bonus1)
                    }
                    updateScore()
                }
                else
                {
                    
                    if power.batteryIsTurbo
                    {
                        if settings.AudioEffects!
                        {
                            power.sprite?.run(sounds.bonus1)
                        }
                        
                        sounds.stopMusic()
                        sounds.playMusic(track: MUSICSFX.FunkyBeatsFaster)
                        
                        MessageRise(message: "Turbo!", position: CGPoint(x: 0, y: 20))
                        GoodGuy.speed = 4
                        power.turboActive = true
                        GoodGuy.turboTime = currentGameTime
                        FlashGoodGuy(flash: true)
                        
                    }
                    else
                    {
                        if settings.AudioEffects!
                        {
                            power.sprite?.run(sounds.bonus2)
                        }
                        
                        MessageRise(message: "Recharge!", position: CGPoint(x: 0, y: 20))
                        
                        score += 5
                        updateScore()
                        if settings.AudioEffects!
                        {
                            self.run(sounds.kaching)
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                GoodGuy.energy = 1000.0
                
                PickNewBatteryLocation()
                
            }
        }
        
        
        
        // Battery - picked up by baddies
        
        
        if (collide(firstNode: firstNode, secondNode: secondNode, firstSpriteBitMask: SpriteCategories.badguyCategory, secondSpriteBitMask: SpriteCategories.batteryCategory))
        {
            
            if (power.active)
            {
                power.active = false
                
                print("bad guys got power")
                
                PickNewBatteryLocation()
                
            }
            
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    func PickNewBatteryLocation()
    {
        
        // Get rid of existing location, then pick a new one
        
        power.battery(isHidden:  true)
        power.setPosition(pos: CGPoint(x:2000, y:2000))
        
        
        if  (Int(arc4random_uniform(7) + 1) > 5) && !bonusLevel // DEBUG
        {
            power.setType(isTurbo: true)
            
        }
        else
        {
            power.setType(isTurbo: false)
        }
        
        
        let delayTime = DispatchTime.now() + .seconds(3) // After 5 secs go for it.
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.power.setPosition(pos: self.RandomLocationSmallRange())    //  self.power.setPosition(pos: CGPoint(x:0, y:0))
            self.power.battery(isHidden:  false)
        }
    }
    
    
    
    
    
    
    
    func processMap()
    {
        
        // Process the tilemap, looking for tiles marked with a specific value to make them "collidable"
        
        let tileWidth = Int((tileMap?.tileSize.width)!)
        let tileHeight = Int((tileMap?.tileSize.height)!)
        
        let numberOfRows = Int((tileMap?.mapSize.width)!/CGFloat(tileWidth))
        let numberOfColumns = Int((tileMap?.mapSize.height)!/CGFloat(tileHeight))
        
        
        for y in 0..<(numberOfColumns)// the -1 is a fix for a bug. if you change tilemap dimensions later, it's broken.
        {
            for x in 0..<(numberOfRows) // the -1 is a fix for a bug.
            {
                let definition = tileMap?.tileDefinition(atColumn: x, row: y)
                
                
                if definition != nil
                {
                    let tileType = definition?.userData?.value(forKey: "type") as! Int
                    if (tileType == 1  ) // Hard ground, so box is fine.
                    {
                        
                        // Create a brand new sprite purely for the collision detection.
                        
                        // Get the texture to recreate it as a sprite
                        let imageTexture = definition?.textures[0]
                        let newNode = SKSpriteNode(texture: imageTexture)
                        
                        // Create the sprite
                        newNode.position = CGPoint(x: x*tileWidth - (numberOfRows/2)*tileWidth , y: y*tileHeight - (numberOfColumns/2)*tileHeight)
                        newNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:tileWidth,height:tileHeight))
                        newNode.physicsBody?.isDynamic = false
                        
                        tileMap?.addChild(newNode)
                        
                    }
                    
                    if (tileType == 4 || tileType == 5 || tileType == 8 || tileType == 7 ) // trickier shapes e.g. ramps
                    {
                        
                        // Create a brand new sprite purely for the collision detection.
                        
                        // Get the texture to recreate it as a sprite
                        let imageTexture = definition?.textures[0]
                        let newNode = SKSpriteNode(texture: imageTexture)
                        
                        // Create the sprite
                        newNode.position = CGPoint(x: x*tileWidth - (numberOfRows/2)*tileWidth , y: y*tileHeight - (numberOfColumns/2)*tileHeight)
                        newNode.physicsBody = SKPhysicsBody(texture: imageTexture!, alphaThreshold: 0.5, size: CGSize(width: tileWidth, height: tileHeight))
                        newNode.physicsBody?.isDynamic = false
                        
                        
                        tileMap?.addChild(newNode)
                    }
                }
                else
                {
                    //  print("-", terminator: " ");
                }
                
            }
            
        }
        
    }
    
    
    
    
    func TestWall(x: Int, y: Int) -> Bool{
        
        if x < 0 || y < 0
        {
            print("******************* BOUNDARY ERROR  ***************")
            assert(false)
        }
        
        let definition = tileMap?.tileDefinition(atColumn: x  , row: y )
        
        if definition == nil
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    func CalculateDirectionHuman( cx : Int, cy : Int, tx : Int, ty : Int) -> Direction
    {
        return GoodGuy.nextDirection
    }
    
    func CalculateDirectionRobot( cx : Int, cy : Int, tx : Int, ty : Int) -> Direction
    {
        if cx > tx  { return .left  }
        if cx < tx  { return .right }
        if cy > ty  { return .down  }
        if cy < ty  { return .up    }
        return .none // or random
    }
    
    
    
    
    func Decode(state : GameState) -> String
    {
        
        return String(state.rawValue)
        
    }
    
    func gameState_Playing()
    {
        
        UpdatePassenger()
        
        var s = 2
        var i = 0
        // If the bad guys have a path, follow it. Otherwise, head to the player. Destroy Will Robinson!
        
        if bonusLevel
        {
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1,test: TestWall)
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1,test: TestWall)
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1,test: TestWall)
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1,test: TestWall)
        }
        else
        {
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1, test: TestWall)
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1, test: TestWall)
            GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1, test: TestWall)
            
            if GoodGuy.speed == 4
            {
                GoodGuy.Update(direction : CalculateDirectionHuman, targetX: 0, targetY: 0, speed: 1, test: TestWall)
            }
        }
        
        camera?.position = GoodGuy.position()
        
        
        if carsStalled
        {
            return
        }
        
        for bad in BadGuys
        {
            if (bad.carX > 1000)
            {
                print ("**************************")
            }
            
            if bad.stuck
            {
                // create plop
                print("e - Make new path \(bad.carX, bad.carY)")
                //  let From = convertCars(xx: Int((bad.carX)), yy: Int((bad.carY)))
                // let To = convertCars(xx: Int(person.pickup_position().x), yy: Int(person.pickup_position().y))
                //  bad.setPath(newPath: createPath(fromX: bad.carX, fromY: bad.carY, toX: 0, toY: 0))
                //  bad.stuck = false
                
            }
            else
            {
                //   print("  No new path \(bad.carX, bad.carY)")
            }
            
        }
        
        
        for bad in BadGuys
        {
            if (bad.path.count>0)
            {
                
                bad.FollowPath(speed: 1)
                bad.FollowPath(speed: 1)
                
                if s == 4
                {
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                }
                
                if (gameLevel == 13)
                {
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    bad.FollowPath(speed: 1)
                    
                }
                
            }
            else
            {
                //if bad.waitingForNewPath
                // {
                let From = convertCars(xx: Int((bad.carX)), yy: Int((bad.carY)))
                let To = convertCars(xx: Int(GoodGuy.position().x), yy: Int(GoodGuy.position().y))
                bad.setPath(newPath: createPath(fromX: From.0, fromY: From.1, toX: To.0, toY: To.1))
                // }
                
            }
            
            i += 1
            
            if (i>7) { s = 4 }
        }
        
        for looper in LoopGuys
        {
            looper.LoopPath(speed: 4)
        }
        
    }
    
    
    func PickANewPathForCar(bad : Car, person: Passenger)
    {
        
        
        if bad.waitingForNewPath == true
        {
            
            if gameLevel == 13
            {
                
                // Go after pick up
                print("a")
                let From = convertCars(xx: Int((bad.carX)), yy: Int((bad.carY)))
                let To = convertCars(xx: Int(person.pickup_position().x), yy: Int(person.pickup_position().y))
                bad.setPath(newPath: createPath(fromX: From.0, fromY: From.1, toX: To.0, toY: To.1))
                
            }
            else
            {
                
                if (Int(arc4random_uniform(6) + 1) > 3) && !bonusLevel
                {
                    if (bonusLevel)
                    {
                        // Go after battery up
                        // print("b")
                        let From = convertCars(xx: Int((bad.carX)), yy: Int((bad.carY)))
                        let To = convertCars(xx: Int(power.position().x), yy: Int(power.position().y))
                        bad.setPath(newPath: createPath(fromX: From.0, fromY: From.1, toX: To.0, toY: To.1))
                    }
                    else
                    {
                        // Go after pick uo
                        // print("c")
                        let From = convertCars(xx: Int((bad.carX)), yy: Int((bad.carY)))
                        let To = convertCars(xx: Int(person.pickup_position().x), yy: Int(person.pickup_position().y))
                        bad.setPath(newPath: createPath(fromX: From.0, fromY: From.1, toX: To.0, toY: To.1))
                    }
                    
                }
                else // create a path to the current position of the player's car
                {
                    // go after user
                    // print("d")
                    // print("I should be at a node, because \(bad.waitingForNewPath) but I'm at \(bad.position())")
                    let From = convertCars(xx: Int((bad.carX)), yy: Int((bad.carY)))
                    let To = convertCars(xx: Int(GoodGuy.position().x), yy: Int(GoodGuy.position().y))
                    bad.setPath(newPath: createPath(fromX: From.0, fromY: From.1, toX: To.0, toY: To.1))
                }
            }
        }
        //   bad.waitingForNewPath = false
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            if item.type == .menu {
                print("Pause")
                
            }
        }
        
    }
    
    
    func DayTime() -> Bool
    {
        if settings.DayNightMode! == false
        {
            return true
        }
        
        let date = NSDate()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date as Date)
        
        
        if hour > 21 || hour < 8
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    
    
    func prepareLevel()
    {
        
        
        
        exploding = false
        score = 0
        GoodGuy.energy = 1000
        
        
        sounds.stopMusic()
        
        
        
        for bad in BadGuys
        {
            let r = RandomLocation()
            bad.setPosition(x: Int(r.x), y: Int(r.y), carangle: CGFloat(M_PI_2))
            bad.forcePosition()
        }
        
        
        for (index,looper) in LoopGuys.enumerated() // A bit of magic to get the index of the loop
        {
            looper.prepLooper(startingPoint: index+1)
            looper.forcePosition()
        }
        
        
        GoodGuy.setPosition(x: 0, y: 0, carangle: CGFloat(M_PI_2))
        GoodGuy.StopBlinking()
        
        PickNewBatteryLocation()
        
        updateScore()
        
        personInCar = 0
        carHasBeenEmpty = true
        
        lightningActive = false
        lightningLimit = 7
        lightning?.removeAllActions()
        lightningCount = 3
        labelLightning?.text = String("x\(lightningCount)")
        carsStalled = false
        batteriesCollected = 0
        FlashAllCars(flash: false)
        
        GoodGuy.speed = 2 // DEBUG
        power.turboActive = false
        FlashGoodGuy(flash: false)
        
        if bonusLevel
        {
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let pause = SKAction.wait(forDuration: 2)
            let Sequence = SKAction.sequence([pause,fadeOut ])
            
            labelBonus?.alpha = 1
            labelBonus?.run(Sequence)
            GoodGuy.speed = 4
            sounds.playMusic(track: MUSICSFX.BonusBeats)
        }
        else
        {
            
            sounds.playMusic(track: MUSICSFX.FunkyBeats)
            
        }
        
        
        // Day or night
        
        if DayTime()
        {
            HeadlightsMask?.isHidden = true  // Night-time mode on/off.
        }
        else
        {
            HeadlightsMask?.isHidden = false
        }
        
    }
    
    
    func MessageRise(message: String, position: CGPoint)
    {
        
        
        
        let fadein = SKAction.fadeIn(withDuration: 0.3)
        let grow = SKAction.scale(by: 2.2, duration: 1.0)
        let fadeout = SKAction.fadeOut(withDuration: 0.5)
        let pause = SKAction.wait(forDuration: 0.70)
        
        
        for i in 0..<6
        {
            
            let p = SKLabelNode(text: message)
            
            switch (i)
            {
            case 0: p.fontColor = UIColor .green; p.zPosition = 20
            case 1: p.fontColor = UIColor .red; p.zPosition = 20
            case 2: p.fontColor = UIColor .green; p.zPosition = 20
            case 3: p.fontColor = UIColor .blue; p.zPosition = 20
            case 4: p.fontColor = UIColor .yellow; p.zPosition = 20
            case 5: p.fontColor = UIColor .white; p.zPosition = 40
            default: break
            }
            
            p.alpha = 0.5
            p.fontSize = 32
            p.fontName = "Courier-Bold"
            p.position = position
            gameCamera?.addChild(p)
            
            let rise = SKAction.moveBy(x: 0, y: -12, duration: 1.0 - (Double(i)/20))
            
            p.run(fadein)
            p.run(grow)
            p.run(rise)
            
            let Sequence1 = SKAction.sequence([pause, fadeout])
            p.run(Sequence1)
            
            
        }
        
        
        
    }
    
    var timer = 0
    var batteriesCollected = 0
    
    func updateScore()
    {
        if bonusLevel
        {
            labelScore?.text="\(batteriesCollected)"
            labelTarget?.text = "/5"
            MessageRise(message: String(format:"\(batteriesCollected)"), position: (labelScore?.position)!)
            if (batteriesCollected > 4)
            {
                LevelComplete()
            }
        }
        else
        {
            labelScore?.text = "$\(score)"
            labelTarget?.text = "Goal: $\(gameTarget)"
            
            MessageRise(message: String(format:"$\(score)"), position: (labelScore?.position)!)
            
            
            if (score > gameTarget)
            {
                LevelComplete()
            }
        }
        
    }
    
    
    override func didSimulatePhysics() {
        
        
        if currentGameState != .exploding
        {
            // Push position after cone collision etc
            GoodGuy.forcePosition()
            
            for bad in BadGuys
            {
                bad.forcePosition()
            }
            
            for loopers in LoopGuys
            {
                loopers.forcePosition()
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        if pause
        {
            return
        }
        
        currentGameTime = currentTime
        
        UpdateRadar()
        
        
        if power.turboActive
        {
            if (currentTime - GoodGuy.turboTime > 9)
            {
                // Turn off turbotime
                power.turboActive = false
                GoodGuy.speed = 2
                FlashGoodGuy(flash: false)
                
                sounds.stopMusic()
                sounds.playMusic(track: MUSICSFX.FunkyBeats)
            }
            
        }
        
        if lightningActive == true
        {
            if lightningTime == 0
            {
                lightningTime = currentTime
            }
            else
            {
                if (currentTime - lightningTime > lightningLimit)
                {
                    
                    // time is up, turn off lightning
                    
                    let zoomIn = SKAction.resize(toWidth: 1, height: 1, duration: 1)
                    let rb = SKAction.run({self.lightning?.isHidden = true})
                    let Sequence = SKAction.sequence([zoomIn,rb ])
                    
                    lightning?.run(Sequence)
                    
                    carsStalled = false
                    FlashAllCars(flash: false)
                    lightningActive = false
                }
                
            }
        }
        
        
        timer += 1
        
        if (GoodGuy.currentDirection != .none && GoodGuy.energy > 0 ) {
            GoodGuy.energy -=  0.2
            energyBar?.size = CGSize(width: GoodGuy.energy/10, height: 8)
            energyBar?.position = CGPoint(x:   -6, y:  -8)
            underEnergyBar?.size = CGSize(width: 100, height: 8)
            
            if (GoodGuy.energy < 150)
            {
                EnergyNode?.run(SKAction.scale(to: 1.50, duration: 0.25))
            }
            
            if (GoodGuy.energy < 100)
            {
                EnergyNode?.run(SKAction.scale(to: 1.80, duration: 0.25))
            }
            
            if GoodGuy.energy <= 0 && currentGameState != .outofenergy1 && currentGameState != .outofenergy2 && !bonusLevel
            {
                currentGameState = .outofenergy1
            }
            
            
        }
        
        
        if (timer>30)
        {
            
            // test every second or so for the indicators
            
            if (GoodGuy.nextDirection == GoodGuy.currentDirection)
            {
                GoodGuy.StopBlinking()
            }
            timer = 0
            
            
        }
        
        
        
        
        if (currentGameState == .starting)
        {
            
            exploding = false
            GoodGuy.StopBlinking()
            gametime = currentTime
            currentGameState = .pre_playing
            prepareLevel()
        }
        
        
        if (currentGameState == .pre_playing)
        {
            gameState_Playing()
            
            
            if (currentTime - gametime > 3)
            {
                currentGameState = .playing
                gametime = currentTime
            }
        }
        
        
        
        
        if (currentGameState == .playing)
        {
            gameState_Playing()
        }
        
        
        
        if (currentGameState == .badcarcontact)
        {
            gametime = currentTime
            
            sounds.stopMusic()
            if settings.AudioEffects!
            {
                self.run(sounds.explode)
            }
            
            if (!exploding)
            {
                MessageRise(message: "CRASH!", position: CGPoint(x: 0, y: 20))
                Explode()
            }
            
            currentGameState = .exploding
            
        }
        
        if (currentGameState == .outofenergy1)
        {
            gametime = currentTime
            sounds.stopMusic()
            
            
            let fadeIn = SKAction.scale(to: 2.0, duration: 0.25)
            let fadeOut = SKAction.scale(to: 1.0, duration: 0.25)
            
            let Sequence = SKAction.sequence([fadeIn, fadeOut])
            
            EnergyNode?.run(SKAction.repeatForever(Sequence))
            
            MessageRise(message: "OUT OF POWER!", position: CGPoint(x: 0, y: 20))
            
            currentGameState = .outofenergy2
            
        }
        
        
        
        if (currentGameState == .outofenergy2)
        {
            if (currentTime - gametime > 5)
            {
                let scene = GameOverScene(fileNamed: "GameOverScene")!
                scene.score = score
                let transition = SKTransition.doorway(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
            }
            
            
        }
        
        
        if (currentGameState == .exploding)
        {
            if (currentTime - gametime > 5)
            {
                if settings.AudioEffects!
                {
                    self.run(sounds.gameover)
                }
                
                if bonusLevel
                {
                    let scene = GameOverBonusScene(fileNamed: "GameOverBonusScene")!
                    scene.score = batteriesCollected
                    let transition = SKTransition.doorway(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
                else
                {
                    let scene = GameOverScene(fileNamed: "GameOverScene")!
                    scene.score = score
                    let transition = SKTransition.doorway(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            
        }
        
        
        
    }
    
    
    
    func LevelComplete()
    {
        if settings.AudioEffects!
        {
            self.run(sounds.overgame)
        }
        sounds.stopMusic()
        
        if (bonusLevel)
        {
            let scene = LevelCompleteScene(fileNamed: "GameOverBonusScene")!
            scene.score = batteriesCollected
            let transition = SKTransition.crossFade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
        }
        else
        {
            let scene = LevelCompleteScene(fileNamed: "LevelCompleteScene")!
            scene.score = score
            scene.level = gameLevel
            let transition = SKTransition.crossFade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    
    // Pathfinding
    
    func convertCars(xx : Int, yy : Int) -> (Int, Int)
    {
        let xxx = Int((xx/64)*64)
        let yyy = Int((yy/64)*64)
        
        
        
        if xx != xxx || yy != yyy
        {
            print("Rounding error \(xx,yy,xxx,yyy)")
            
        }
        
        let cx =  15 + (xxx / 64)
        let cy =  15 + (yyy / 64)
        
        return (cx,cy)
        
    }
    
    
    func unConvertCars(pos : vector_int2) -> (Int, Int)
    {
        let cx =  (pos.x - 15) * 64
        let cy =  (pos.y - 15) * 64
        
        return (Int(cx),Int(cy))
        
    }
    
    
    func roundUpCar(car: Car)
    {
        let pos = car.position()
        let angle = car.angle
        let spos = convertCars(xx: Int(pos.x), yy: Int(pos.y))
        let tpos = unConvertCars(pos: int2(x: Int32(spos.0), y: Int32(spos.1)))
        car.setPosition(x: tpos.0, y: tpos.1, carangle: angle)
    }
    
    func roundUpCars()
    {
        for badcar in BadGuys
        {
            roundUpCar(car: badcar)
        }
        
    }
    
    
    func RandomLocation() -> (CGPoint)
    {
        
        // Get a random location, but not one too close to the center
        
        let tileWidth = Int((tileMap?.tileSize.width)!)
        let tileHeight = Int((tileMap?.tileSize.height)!)
        
        let numberOfRows = Int((tileMap?.mapSize.width)!/CGFloat(tileWidth))
        let numberOfColumns = Int((tileMap?.mapSize.height)!/CGFloat(tileHeight))
        
        while true {
            
            let rows = Int32(arc4random_uniform(UInt32(numberOfRows)))
            let cols = Int32(arc4random_uniform(UInt32(numberOfColumns)))
            let path = roadGraph?.node(atGridPosition: int2(x: rows, y: cols))
            
            
            if (rows < 10 || rows > 20) && (cols < 10 || cols > 20) && path != nil
            {
                return CGPoint(x: CGFloat((rows - 15) * 64), y: CGFloat((cols - 15) * 64))
            }
            
            
        }
        
    }
    
    
    func RandomLocationSmallRange() -> (CGPoint)
    {
        
        // Get a random location, but not one too close to the center
        
        let tileWidth = Int((tileMap?.tileSize.width)!)
        let tileHeight = Int((tileMap?.tileSize.height)!)
        
        let numberOfRows = Int((tileMap?.mapSize.width)!/CGFloat(tileWidth))
        let numberOfColumns = Int((tileMap?.mapSize.height)!/CGFloat(tileHeight))
        
        while true {
            
            let rows = Int32(arc4random_uniform(UInt32(numberOfRows)))
            let cols = Int32(arc4random_uniform(UInt32(numberOfColumns)))
            let path = roadGraph?.node(atGridPosition: int2(x: rows, y: cols))
            
            
            if (rows < 13 || rows > 17) && (cols < 13 || cols > 17) && path != nil
            {
                return CGPoint(x: CGFloat((rows - 15) * 64), y: CGFloat((cols - 15) * 64))
            }
            
            
        }
        
    }
    
    
    
    
    func createGraph()
    {
        let tileWidth = Int((tileMap?.tileSize.width)!)
        let tileHeight = Int((tileMap?.tileSize.height)!)
        
        let numberOfRows = Int((tileMap?.mapSize.width)!/CGFloat(tileWidth))
        let numberOfColumns = Int((tileMap?.mapSize.height)!/CGFloat(tileHeight))
        
        let tempgraph = GKGridGraph(fromGridStartingAt: int2(0, 0), width: Int32(numberOfColumns), height: Int32(numberOfRows), diagonalsAllowed: false)
        
        var walls : Array<GKGraphNode> = []
        
        for y in 0..<(numberOfRows)// the -1 is a fix for a bug. if you change tilemap dimensions later, it's broken.
        {
            for x in 0..<(numberOfColumns) // the -1 is a fix for a bug.
            {
                let definition = tileMap?.tileDefinition(atColumn: x, row: y)
                
                if definition != nil
                {
                    //print("X", terminator:"")
                    walls.append(tempgraph.node(atGridPosition: int2(x:Int32(x), y:Int32(y)))!)
                }
                else
                {
                    // print(" ", terminator:"")
                }
            }
            print()
        }
        
        
        tempgraph.remove(walls)
        
        roadGraph = tempgraph
        
    }
    
    func createPath(fromX: Int, fromY: Int, toX : Int, toY : Int) -> Array<(Int, Int)>
    {
        var pathStuff : Array<(Int, Int)> = []
        
        
        // Must make sure the from is a multiple of 64.
        // the bugs happen when the path is created at a random time, and the from is between nodes.
        
        
        
        
        
        if (fromX > 100 || fromY > 100 || fromX < -100 || fromY < -100)
        {
            print("Being asked the wrong thing... ***************")
            return pathStuff
        }
        
        if (roadGraph == nil)
        {
            print("ERROR! No graph");
        }
        
        if (abs(toX) > 1000)
        {
            print("Error -- sequence error, passenger still off-grid")
        }
        
        
        let carNode  = roadGraph?.node(atGridPosition: int2(x:Int32(fromX), y:Int32(fromY)))
        let targetNode  = roadGraph?.node(atGridPosition: int2(x:Int32(toX), y:Int32(toY)))
        
        
        if carNode == nil
        {
            //   print("Error - unable to get starting point \(fromX,fromY, (fromX - 15) * 64, (fromY - 15) * 64)")
            //   print(roadGraph)
            return pathStuff
        }
        
        
        if targetNode == nil
        {
            print("Error - unable to get to target \(toX,toY, (toX - 15) * 64, (toY - 15) * 64)")
            return pathStuff
        }
        
        let path = roadGraph?.findPath(from: carNode!, to: targetNode!) as! [GKGridGraphNode]
        
        if path.count == 0
        {
            print("Error - path error \(toX,toY, (toX - 15) * 64, (toY - 15) * 64)")
            return pathStuff
        }
        
        
        for n in path
        {
            pathStuff.append(unConvertCars(pos: n.gridPosition))
            // Add the grid co-ord to the path, not the sprite which is large and may get wrong.
            //pathStuff.append((Int(n.gridPosition.x), Int(n.gridPosition.y)))
            
        }
        
        // The path contains the starting point. Let's remove that.
        
        pathStuff.remove(at: 0)
        
        return pathStuff
    }
    
    
    
    
    func Explode()
    {
        
        exploding = true
        
        if DayTime()
        {
            // Don't rotate at night, as the headlights look bad
            GoodGuy.sprite?.physicsBody?.applyForce(CGVector(dx: 150, dy: 50))
            GoodGuy.sprite?.physicsBody?.applyAngularImpulse(0.05)
        }
        
        #if os(tvOS)
            
        #else
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        #endif
        
        #if os(tvOS)
            let zo = SKAction.scale(to: 0.8, duration: 0.05)
            let zi = SKAction.scale(to: 0.6, duration: 0.05)
            let Sequence = SKAction.sequence([zo, zi, zo, zi])
            gameCamera?.run(Sequence)
            
        #else
            let zo = SKAction.scale(to: 1.6, duration: 0.05)
            let zi = SKAction.scale(to: 1.4, duration: 0.05)
            let Sequence = SKAction.sequence([zo, zi, zo, zi])
            gameCamera?.run(Sequence)
            
            
            
        #endif
        
        
        
        let moveX_1 = SKAction.move(by: CGVector(dx: -7.0, dy: 0.0), duration: 0.05)
        let moveX_2 = SKAction.move(by: CGVector(dx: -10.0, dy: 0.0), duration: 0.05)
        let moveX_3 = SKAction.move(by: CGVector(dx: 7.0, dy: 0.0), duration: 0.05)
        let moveX_4 = SKAction.move(by: CGVector(dx: 10.0, dy: 0.0), duration: 0.05)
        let moveY_1 = SKAction.move(by: CGVector(dx: 0, dy: -7.0), duration: 0.05)
        let moveY_2 = SKAction.move(by: CGVector(dx: 0, dy: -10.0), duration: 0.05)
        let moveY_3 = SKAction.move(by: CGVector(dx: 0, dy: 7.0), duration: 0.05)
        let moveY_4 = SKAction.move(by: CGVector(dx: 0.0, dy: 10.0), duration: 0.05)
        
        
        let Sequence1 = SKAction.sequence([moveX_1, moveX_4, moveX_2, moveX_3])
        let Sequence2 = SKAction.sequence([moveY_1, moveY_4, moveY_2, moveY_3])
        
        for node in self.children
        {
            node.run(Sequence1)
            node.run(Sequence2)
        }
        
        
        
        let burstPath = Bundle.main.path(forResource: "spark", ofType: "sks")
        let burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!)  as! SKEmitterNode
        burstNode.position = GoodGuy.position()
        self.addChild(burstNode)
        
        
        let pause = SKAction.wait(forDuration: 0.05)
        let scale = SKAction.scale(by: 1.5, duration: 0.1)
        let rb = SKAction.run({burstNode.particleBirthRate = 0})
        let Sequence3 = SKAction.sequence([scale, pause, rb])
        burstNode.run(Sequence3)
        
        
        
        let smokePath = Bundle.main.path(forResource: "smoke", ofType: "sks")
        let smokeNode = NSKeyedUnarchiver.unarchiveObject(withFile: smokePath!)  as! SKEmitterNode
        smokeNode.position = GoodGuy.position()
        self.addChild(smokeNode)
        
        let rb2 = SKAction.run({smokeNode.particleBirthRate = 0})
        let Sequence4 = SKAction.sequence([scale, pause,pause,pause,pause,pause,pause, rb2])
        smokeNode.run(Sequence4)
        
        
    }
}
