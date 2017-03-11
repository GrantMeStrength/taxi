//
//  SoundEffects.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/24/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//

import SpriteKit
import AVFoundation


class SoundEffects: NSObject {

    let ping = SKAction.playSoundFileNamed("ping.mp3", waitForCompletion: false)
    
    let bonus1 = SKAction.playSoundFileNamed("bonus1.mp3", waitForCompletion: false)
    let bonus2 = SKAction.playSoundFileNamed("bonus2.mp3", waitForCompletion: false)
    let bonus3 = SKAction.playSoundFileNamed("bonus3.mp3", waitForCompletion: false)
    let bonus4 = SKAction.playSoundFileNamed("bonus4.mp3", waitForCompletion: false)
    let kaching = SKAction.playSoundFileNamed("kaching.mp3", waitForCompletion: false)
    let chime = SKAction.playSoundFileNamed("chime.mp3", waitForCompletion: false)
    let gameover = SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false)
    let overgame = SKAction.playSoundFileNamed("OverGame.mp3", waitForCompletion: false)
    let explode = SKAction.playSoundFileNamed("carcrash.mp3", waitForCompletion: false)
    let lightning = SKAction.playSoundFileNamed("electrical.mp3", waitForCompletion: false)
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override init()
    {
        super.init()
        playBackgroundMusic(filename: "ping.mp3");
        backgroundMusicPlayer.stop()
        
    }
    
    func stopMusic()
    {
        backgroundMusicPlayer.stop()
    }
    
    func playMusic(track : MUSICSFX)
    {
        switch (track)
        {
        case .Stop: backgroundMusicPlayer.stop();
        case .FunkyBeats: playBackgroundMusic(filename: "beats2.mp3");
        case .FunkyBeatsFaster: playBackgroundMusic(filename: "beatsFaster2.mp3");
        case .BonusBeats: playBackgroundMusic(filename: "beatsFunky2.mp3");
        }
    }
    
    func playBackgroundMusic(filename: String) {
    
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
   
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.volume = 0.1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
}
