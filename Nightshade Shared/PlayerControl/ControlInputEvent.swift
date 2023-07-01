//
//  ControlInputEvent.swift
//  Created by ifau on 01.07.2023.
//

import Foundation

enum ControlInputEvent {
    case movement(xValue: Float, yValue: Float)
    case pause
}

extension NSNotification.Name {
    static let controlInputEventTriggered = NSNotification.Name("controlInputEventTriggered")
}
