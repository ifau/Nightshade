//
//  InputComponent.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import GameplayKit

class InputComponent: GKComponent {
    
    var isEnabled = true
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: .controlInputEventTriggered, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didReceiveNotification(_ notification: NSNotification) {
        guard let controlInputEvent = notification.object as? ControlInputEvent else { return }
        
        if case let .movement(xValue, yValue) = controlInputEvent,
           let movementComponent = entity?.component(ofType: MovementComponent.self) {
            
            movementComponent.isJumping = yValue > 0.5
            movementComponent.isMovingLeft = xValue < -0.5
            movementComponent.isMovingRight = xValue > 0.5
        }
        
    }
}
