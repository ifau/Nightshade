//
//  PhysicsComponent.swift
//  Created by ifau on 01.07.2023.
//

import SpriteKit
import GameplayKit

enum PhysicsCategories {
    static let player: UInt32 = 1 << 0
    static let ground: UInt32 = 1 << 1
}

class PhysicsComponent: GKComponent {
    // MARK: Properties
    
    var physicsBody: SKPhysicsBody
    
    // MARK: Initializers
    
    init(physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
