//
//  ParallaxComponent.swift
//  Created by ifau on 01.07.2023.
//

import SpriteKit
import GameplayKit

class ParallaxComponent: GKComponent {
    
    enum ParallaxDepthLevel: UInt32 {
        // 0 is the closest to the camera
        case level0, level1, level2, level3, level4, level5, level6
    }
    
    var cameraNode: SKCameraNode?
    var depthLevel: ParallaxDepthLevel = .level6
    var previousCameraPosition: CGPoint = .zero
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else { fatalError("A ParallaxComponent's entity must have a RenderComponent") }
        return renderComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        guard let camera = cameraNode else { return }
        
        let offsetX = (camera.position.x - previousCameraPosition.x) / depthLevel.dx
        let offsetY = (camera.position.y - previousCameraPosition.y) / depthLevel.dy
        
        renderComponent.node.position.x += offsetX
        renderComponent.node.position.y += offsetY
        
        previousCameraPosition = camera.position
    }
}

extension ParallaxComponent.ParallaxDepthLevel {
    
    var delta: (CGFloat, CGFloat) {
        switch self {
        case .level0: return (10, 5)
        case .level1: return (8, 4)
        case .level2: return (5, 2)
        case .level3: return (2, 1.9)
        case .level4: return (1.7, 1.5)
        case .level5: return (1.3, 1.25)
        case .level6: return (1.1, 1.2)
        }
    }
    
    var dx: CGFloat { delta.0 }
    var dy: CGFloat { delta.1 }
}
