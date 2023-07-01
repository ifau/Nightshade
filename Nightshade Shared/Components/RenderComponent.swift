//
//  RenderComponent.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import GameplayKit

class RenderComponent: GKComponent {
    
    // The `RenderComponent` vends a node allowing an entity to be rendered in a scene.
    let node: SKNode
    
    init(_ node: SKNode? = nil) {
        self.node = node ?? SKNode()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil
    }
}
