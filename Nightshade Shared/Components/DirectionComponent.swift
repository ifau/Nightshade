//
//  DirectionComponent.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import GameplayKit

enum Direction {
    case left, right
}

class DirectionComponent: GKComponent {
    var direction: Direction = .left
}
