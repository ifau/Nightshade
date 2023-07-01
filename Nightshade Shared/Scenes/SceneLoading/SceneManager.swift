//
//  SceneManager.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import SpriteKit

final class SceneManager {
    
    let presentingView: SKView
    
    init(presentingView: SKView) {
        self.presentingView = presentingView
    }
    
    func presentScene(identifier sceneIdentifier: SceneIdentifier) {
        guard let scene: BaseScene = sceneIdentifier.sceneType.init(fileNamed: sceneIdentifier.sceneFileName) else {
            fatalError("Cannot instantiate scene with filename \(sceneIdentifier.sceneFileName)")
        }
        
        scene.sceneIdentifier = sceneIdentifier
        scene.sceneManager = self
        presentingView.presentScene(scene, transition: SKTransition.fade(withDuration: 0.2))
    }
}
