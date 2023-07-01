//
//  BaseScene+Touch.swift
//  Created by ifau on 01.07.2023.
//

#if os(iOS)
import UIKit
extension BaseScene {
    
    func addTouchControlInputNode() {
        guard self is LevelScene else { return }
        guard let camera = camera else {
            fatalError("Touch input controls can only be added to a scene that has an associated camera.")
        }
        
        let controlSize = min(size.width, size.height) * 0.2
        let touchControlInputNode = TouchControlInputNode(frame: frame, thumbStickNodeSize: CGSize(width: controlSize, height: controlSize))
        
        touchControlInputNode.zPosition = LevelScene.WorldLayer.top.rawValue - CGFloat(1.0)
        
        camera.addChild(touchControlInputNode)
        touchControlInputNode.hideThumbStickNodes = false
    }
}
#endif
