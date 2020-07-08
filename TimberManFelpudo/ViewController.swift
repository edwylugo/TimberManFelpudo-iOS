//
//  ViewController.swift
//  TimberManFelpudo
//
//  Created by Edwy Lugo on 25/02/20.
//  Copyright © 2020 Edwy Lugo. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let minhaView: SKView = SKView(frame: self.view.frame)
        self.view = minhaView
        
        let minhaCena: MinhaCena = MinhaCena(size:minhaView.frame.size)
        minhaView.contentMode = .scaleAspectFill
        minhaView.presentScene(minhaCena)
        minhaView.ignoresSiblingOrder = false
        minhaView.showsFPS = true
        minhaView.showsNodeCount = true
        minhaView.showsPhysics = true
        
        
    }


}

