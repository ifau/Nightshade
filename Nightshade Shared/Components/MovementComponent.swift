//
//  MovementComponent.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import GameplayKit

class MovementComponent: GKComponent {
    
    var isJumping = false
    var isMovingRight = false
    var isMovingLeft = false
    
    var speed: CGFloat = 5
    
    private var applyImpulsForJumpDuration: TimeInterval = 0.0
    private let maxApplyImpultForJumpDuration: TimeInterval = 0.1
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else { fatalError("A MovementComponent's entity must have a RenderComponent") }
        return renderComponent
    }

    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { fatalError("A MovementComponent's entity must have an AnimationComponent") }
        return animationComponent
    }
    
    var directionComponent: DirectionComponent {
        guard let orientationComponent = entity?.component(ofType: DirectionComponent.self) else { fatalError("A MovementComponent's entity must have an DirectionComponent") }
        return orientationComponent
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let isStandOnGround = renderComponent.node.physicsBody?.allContactedBodies().first(where: { $0.categoryBitMask == PhysicsCategories.ground }) != nil
        
        if isMovingLeft {
            renderComponent.node.position.x -= speed
            animationComponent.requestedAnimationType = isStandOnGround ? .run : .jump
            directionComponent.direction = .left
        }
        if isMovingRight {
            renderComponent.node.position.x += speed
            animationComponent.requestedAnimationType = isStandOnGround ? .run : .jump
            directionComponent.direction = .right
        }
        if isJumping && applyImpulsForJumpDuration <= maxApplyImpultForJumpDuration {
            renderComponent.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            animationComponent.requestedAnimationType = .jump
            applyImpulsForJumpDuration += seconds
        }
        if !isMovingLeft, !isMovingRight, !isJumping {
            animationComponent.requestedAnimationType = isStandOnGround ? .idle : .jump
        }
        
        if applyImpulsForJumpDuration > maxApplyImpultForJumpDuration, isStandOnGround {
            applyImpulsForJumpDuration = 0
        }
    }
}
