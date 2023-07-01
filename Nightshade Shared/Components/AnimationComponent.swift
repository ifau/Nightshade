//
//  AnimationComponent.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import GameplayKit

enum AnimationType {
    case idle
    case run
    case jump
}

struct Animation {
    let animationType: AnimationType
    let textures: [SKTexture]
    let repeatForever: Bool
    let timePerFrame: TimeInterval
}

class AnimationComponent: GKComponent {
    
    static let textureActionKey = "textureAction"
    
    var requestedAnimationType: AnimationType?
    var animations: [AnimationType : Animation]
    
    /// The node on which animations should be run for this animation component.
    let node: SKSpriteNode
    
    private(set) var currentAnimationType: AnimationType?
    private(set) var currentDirection: Direction?
    
    init(textureSize: CGSize, animations: [AnimationType : Animation]) {
        node = SKSpriteNode(texture: nil, size: textureSize)
        self.animations = animations
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let animationType = requestedAnimationType else { return }
        let direction = entity?.component(ofType: DirectionComponent.self)?.direction ?? .right
        
        runAnimation(type: animationType, direction: direction, deltaTime: seconds)
        requestedAnimationType = nil
    }
    
    private func runAnimation(type: AnimationType, direction: Direction, deltaTime: TimeInterval) {
        
        if let currentAnimationType = currentAnimationType,
           let currentDirection = currentDirection,
           currentAnimationType == type,
           currentDirection == direction {
            return
        }
        
        guard let animation = animations[type] else { return }
        let texturesAction: SKAction
        if animation.textures.count == 1, let firstTexture = animation.textures.first {
            // If the new animation only has a single frame, create a simple "set texture" action.
            texturesAction = SKAction.setTexture(firstTexture)
        } else {
            texturesAction = animation.repeatForever
            ? SKAction.repeatForever(SKAction.animate(with: animation.textures, timePerFrame: animation.timePerFrame))
            : SKAction.animate(with: animation.textures, timePerFrame: animation.timePerFrame)
        }
        
        node.removeAction(forKey: AnimationComponent.textureActionKey)
        node.run(texturesAction, withKey: AnimationComponent.textureActionKey)
        
        switch direction {
        case .left: node.xScale = abs(node.xScale) * -1.0
        case .right: node.xScale = abs(node.xScale) * 1.0
        }
        
        currentAnimationType = type
        currentDirection = direction
    }
}
