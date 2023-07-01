//
//  SceneIdentifier.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import SpriteKit

enum SceneIdentifier {
    case mainMenu
    case level(Int)
}

extension SceneIdentifier {
    
    var sceneType: BaseScene.Type {
        switch self {
        case .mainMenu: return MainMenuScene.self
        case .level(_): return LevelScene.self
        }
    }
    
    var sceneFileName: String {
        switch self {
        case .mainMenu: return "MainMenu.sks"
        case .level(let number): return "Level_\(number)"
        }
    }
}
