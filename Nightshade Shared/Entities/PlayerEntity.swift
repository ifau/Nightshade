//
//  PlayerEntity.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    static var textureSize = CGSize(width: 128, height: 128)
    static var animations: [AnimationType: Animation]?
    
    var renderComponent: RenderComponent {
        guard let renderComponent = component(ofType: RenderComponent.self) else {
            fatalError("A PlayerEntity must have an RenderComponent.")
        }
        return renderComponent
    }
    
    override init() {
        
        super.init()
        
        let renderComponent = RenderComponent()
        addComponent(renderComponent)
        
        let directionComponent = DirectionComponent()
        addComponent(directionComponent)
        
        let movementComponent = MovementComponent()
        addComponent(movementComponent)
        
        let inputComponent = InputComponent()
        addComponent(inputComponent)
        
        loadAnimations()
        guard let animations = PlayerEntity.animations else {
            fatalError("Attempt to access PlayerEntity.animations before they have been loaded.")
        }
        let animationComponent = AnimationComponent(textureSize: PlayerEntity.textureSize, animations: animations)
        addComponent(animationComponent)
        
        renderComponent.node.addChild(animationComponent.node)
        
        let physicsBody = SKPhysicsBody(rectangleOf: PlayerEntity.textureSize)
        physicsBody.isDynamic = true
        physicsBody.allowsRotation = false
        physicsBody.friction = 0.0
        physicsBody.restitution = 0.0
        physicsBody.categoryBitMask = PhysicsCategories.player
        physicsBody.contactTestBitMask = PhysicsCategories.ground
        
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody)
        addComponent(physicsComponent)
        
        renderComponent.node.physicsBody = physicsComponent.physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerEntity {
    
    private func loadAnimations() {
        
        if let _ = PlayerEntity.animations { return }
        var animations: [AnimationType: Animation] = [:]
        
        do {
            let atlas = SKTextureAtlas(named: "player-idle")
            let frames: [SKTexture] = atlas.textureNames.map { atlas.textureNamed($0) }
            animations[.idle] = Animation(animationType: .idle, textures: frames, repeatForever: true, timePerFrame: 1.5)
        }
        do {
            let atlas = SKTextureAtlas(named: "player-run")
            let frames: [SKTexture] = atlas.textureNames.map { atlas.textureNamed($0) }
            animations[.run] = Animation(animationType: .run, textures: frames, repeatForever: true, timePerFrame: 0.1)
        }
        do {
            let atlas = SKTextureAtlas(named: "player-jump")
            let frames: [SKTexture] = atlas.textureNames.map { atlas.textureNamed($0) }
            animations[.jump] = Animation(animationType: .jump, textures: frames, repeatForever: true, timePerFrame: 0.1)
        }
        
        PlayerEntity.animations = animations
    }
}
