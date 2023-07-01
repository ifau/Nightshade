//
//  GameViewController.swift
//  Created by ifau on 01.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    lazy var sceneView: SKView = {
        let view = self.view as! SKView
        
//        view.ignoresSiblingOrder = true
//        view.showsFPS = true
//        view.showsNodeCount = true
//        view.showsPhysics = true
        
        return view
    }()
    
    lazy var sceneManager: SceneManager = {
        SceneManager(presentingView: sceneView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneManager.presentScene(identifier: .level(1))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
