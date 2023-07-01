//
//  LevelScene+Configuration.swift
//  Created by ifau on 01.07.2023.
//

import Foundation

extension LevelScene {
    
    var sceneSize: CGSize {
        guard case let .level(number) = sceneIdentifier else {
            fatalError("Instance of LevelScene must have an .level sceneIdentifier")
        }
        switch number {
        default: return CGSize(width: 4096, height: 2048)
        }
    }
}
