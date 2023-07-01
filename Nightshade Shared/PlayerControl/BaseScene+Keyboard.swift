//
//  BaseScene+Keyboard.swift
//  Created by ifau on 01.07.2023.
//

import Foundation
import SpriteKit

#if os(OSX)
fileprivate var keyboardInputHandler = KeyboardControlInputHandler()
extension BaseScene {
    
    override func keyUp(with event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }
        characters.forEach { keyboardInputHandler.handleKeyUp(forCharacter: $0) }
    }
    
    override func keyDown(with event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }
        characters.forEach { keyboardInputHandler.handleKeyDown(forCharacter: $0) }
    }
}
#endif
