//
//  LevelScene+WorldLayer.swift
//  Created by ifau on 01.07.2023.
//

import Foundation

extension LevelScene {
    
    enum WorldLayer: CGFloat {
        
        case top = 2000
        case aboveCharacters = 1000
        case characters = 0
        case ground = -25
        case background = -100
        
        // The expected name for this node in the scene file.
        var nodeName: String {
            switch self {
            case .top: return "top"
            case .aboveCharacters: return "above_characters"
            case .characters: return "characters"
            case .ground: return "ground"
            case .background: return "background"
            }
        }
        
        var nodePath: String {
            return "/world/\(nodeName)"
        }

        static var allLayers = [top, aboveCharacters, characters, ground, background]
    }
}
