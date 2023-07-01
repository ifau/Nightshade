//
//  KeyboardControlInputHandler.swift
//  Created by ifau on 01.07.2023.
//

import Foundation

class KeyboardControlInputHandler {
    
    var currentDisplacement = SIMD2<Float>()
    var downKeys = Set<Character>()
    
    func handleKeyDown(forCharacter character: Character) {
        // Ignore repeat input.
        guard !downKeys.contains(character) else { return }
        downKeys.insert(character)
        
        if let relativeDisplacement = relativeDisplacementForCharacter(character) {
            currentDisplacement += relativeDisplacement
            NotificationCenter.default.post(name: .controlInputEventTriggered, object: ControlInputEvent.movement(xValue: currentDisplacement.x, yValue: currentDisplacement.y))
        }
    }
    
    func handleKeyUp(forCharacter character: Character) {
        // Ensure the character was accounted for by `handleKeyDown(forCharacter:)`.
        guard downKeys.remove(character) != nil else { return }
        
        if let relativeDisplacement = relativeDisplacementForCharacter(character) {
            currentDisplacement -= relativeDisplacement
            
            if downKeys.isEmpty {
                currentDisplacement = SIMD2<Float>()
            }
            NotificationCenter.default.post(name: .controlInputEventTriggered, object: ControlInputEvent.movement(xValue: currentDisplacement.x, yValue: currentDisplacement.y))
        }
    }
    
    private func relativeDisplacementForCharacter(_ character: Character) -> SIMD2<Float>? {
        
        switch character {
        case "w", Character(UnicodeScalar(0xF700)!): return SIMD2<Float>(x: 0, y: 1)
        case "s", Character(UnicodeScalar(0xF701)!): return SIMD2<Float>(x: 0, y: -1)
        case "a", Character(UnicodeScalar(0xF702)!): return SIMD2<Float>(x: -1, y: 0)
        case "d", Character(UnicodeScalar(0xF703)!): return SIMD2<Float>(x: 1, y: 0)
        default: return nil
        }
    }
}
