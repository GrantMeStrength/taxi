//
//  MenuBottonView.swift
//  LunarLander
//
//  Created by John Kennedy on 12/19/15.
//  Copyright © 2015 CraicDesign. All rights reserved.
//

import UIKit

class MenuBottonView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBOutlet weak var buttonContinue: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    func AskForFocus()
    {
      //  print("I am trying!")
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
    }
/*
    override func canBecomeFocused() -> Bool {
        print("Can be focused?")
        return true
    }
*/

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let button = buttonContinue {
            return [button]
        }
        return []
    }


}
