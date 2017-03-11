//
//  Settings.swift
//  TileMapPhysics
//
//  Created by John Kennedy on 9/11/16.
//  Copyright © 2016 CraicDesign. All rights reserved.
//

import UIKit



// Save and Load game settings

class Settings: NSObject {

    var DayNightMode : Bool? = true
    var AudioEffects : Bool? = true
    
    
    func SaveLevel(level : Int)
    {
        let defaults = UserDefaults.standard
        
        defaults.setValue(level, forKey: "HighestLevel")
        defaults.setValue(DayNightMode, forKey: "DayNightMode")
        defaults.setValue(AudioEffects, forKey: "AudioEffects")
        

    }
    
    func Load() -> Int
    {
        let defaults = UserDefaults.standard
        
        DayNightMode = defaults.value(forKey: "DayNightMode") as? Bool
        
        if DayNightMode == nil
        {
            DayNightMode = true
        }

        AudioEffects = defaults.value(forKey: "AudioEffects") as? Bool
        
        if AudioEffects == nil
        {
            AudioEffects = true
        }

        
        let level : Int? = defaults.value(forKey: "HighestLevel") as? Int
        
        if (level == nil)
        {
            return 1 // Even when nothing has been saved, you can play level 1.
        }
        else
        {
            return level!
        }
        
        
        
    }
    
}
