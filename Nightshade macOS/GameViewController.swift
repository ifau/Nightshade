//
//  GameViewController.swift
//  Created by ifau on 01.07.2023.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    
    lazy var sceneView: SKView = {
        let view = self.view as! SKView
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        //view.showsPhysics = true
        
        return view
    }()
    
    lazy var sceneManager: SceneManager = {
        SceneManager(presentingView: sceneView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneManager.presentScene(identifier: .level(1))
    }
}

