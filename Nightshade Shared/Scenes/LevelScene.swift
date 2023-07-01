//
//  LevelScene.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import SpriteKit
import GameplayKit

class LevelScene: BaseScene {
    
    let playerEntity = PlayerEntity()
    var entities = Set<GKEntity>()
    
    lazy var worldLayerNodes: [WorldLayer: SKNode] = {
        WorldLayer.allLayers.reduce([WorldLayer: SKNode]()) { (dict, layer) in
            guard let layerNode = self["world/\(layer.nodeName)"].first else {
                fatalError("Could not find a world layer node for \(layer.nodeName)")
            }
            var dict = dict
            layerNode.zPosition = layer.rawValue
            dict[layer] = layerNode
            return dict
        }
    }()
    lazy var worldNode: SKNode = {
        childNode(withName: "world")!
    }()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let movementSystem = GKComponentSystem(componentClass: MovementComponent.self)
        
        // The systems will be updated in order. This order is explicitly defined to match assumptions made within components.
        return [movementSystem, animationSystem]
    }()
    
    var lastUpdateTimeInterval: TimeInterval = 0
    let maximumUpdateDeltaTime: TimeInterval = 1.0 / 60.0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)

#if os(iOS)
        addTouchControlInputNode()
#endif
        addPlayerToScene()
        setSceneConstraints()
        
        worldLayerNodes[.ground]?.children.forEach({
            $0.physicsBody?.categoryBitMask = PhysicsCategories.ground
            $0.physicsBody?.collisionBitMask = 0
        })
        
        worldLayerNodes[.background]?.children.enumerated().forEach({ (index, element) in
            element.zPosition += WorldLayer.background.rawValue + CGFloat(index)
        })
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        setCameraConstraints()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard view != nil else { return }
        
        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ? maximumUpdateDeltaTime : deltaTime
        
        lastUpdateTimeInterval = currentTime
        
        if worldNode.isPaused { return }
        
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
    }
}

private extension LevelScene {
    
    func addPlayerToScene() {
        guard let playerLocation = worldLayerNodes[.characters]?.childNode(withName: "PlayerLocation") else {
            fatalError("Characters layer doesn't contains PlayerLocation node)")
        }
        addEntity(entity: playerEntity, toWorldLayer: .characters)
        playerEntity.renderComponent.node.position = playerLocation.position
        setCameraConstraints()
    }
    
    func addEntity(entity: GKEntity, toWorldLayer worldLayer: WorldLayer) {
        entities.insert(entity)

        for componentSystem in self.componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let renderNode = entity.component(ofType: RenderComponent.self)?.node {
            worldLayerNodes[worldLayer]?.addChild(renderNode)
        }
    }
    
    private func setCameraConstraints() {
        
        guard let camera = camera else { return }

        let playerLocationConstraint = SKConstraint.distance(SKRange(constantValue: 0.0), to: playerEntity.renderComponent.node)

        let scaledSize = CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
        let levelContentRect = CGRect(origin: .zero, size: sceneSize)

        let xInset = min((scaledSize.width / 2), levelContentRect.width / 2)
        let yInset = min((scaledSize.height / 2), levelContentRect.height / 2)
        
        let insetContentRect = levelContentRect.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)

        camera.constraints = [playerLocationConstraint, levelEdgeConstraint]
    }
    
    private func setSceneConstraints() {
        let border = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: sceneSize.width, height: sceneSize.height))
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
    }
}
