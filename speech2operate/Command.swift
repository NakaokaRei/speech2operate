//
//  Command.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/09.
//

import Foundation
import SwiftAutoGUI

enum Command {

    case mouse(direction: Direction, distance: Int)
    case keyboard(shortcut: [Key])
    case scroll(direction: Direction, distance: Int)

    enum Direction {
        case up
        case down
        case left
        case right
    }
}

extension Command {

    init?(_ command: String) {
        if command.contains("マウス") {
            if command.contains("右") {
                self = .mouse(direction: .right, distance: 20)
            } else if command.contains("左") {
                self = .mouse(direction: .left, distance: 20)
            } else if command.contains("上") {
                self = .mouse(direction: .up, distance: 20)
            } else if command.contains("下") {
                self = .mouse(direction: .down, distance: 20)
            } else {
                return nil
            }
        } else if command.contains("デスクトップ") {
            if command.contains("右") {
                self = .keyboard(shortcut: [.control, .rightArrow])
            } else if command.contains("左") {
                self = .keyboard(shortcut: [.control, .leftArrow])
            } else {
                return nil
            }
        } else if command.contains("スクロール") {
            if command.contains("下") {
                self = .scroll(direction: .down, distance: 20)
            } else if command.contains("上") {
                self = .scroll(direction: .up, distance: 20)
            } else if command.contains("右") {
                self = .scroll(direction: .right, distance: 20)
            } else if command.contains("左") {
                self = .scroll(direction: .left, distance: 20)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func process() {
        switch self {
        case .mouse(let direction, let distance):
            switch direction {
            case .up:
                SwiftAutoGUI.moveMouse(dx: 0, dy: -CGFloat(distance))
            case .down:
                SwiftAutoGUI.moveMouse(dx: 0, dy: CGFloat(distance))
            case .left:
                SwiftAutoGUI.moveMouse(dx: CGFloat(distance), dy: 0)
            case .right:
                SwiftAutoGUI.moveMouse(dx: -CGFloat(distance), dy: 0)
            }
        case .keyboard(let shortcut):
            SwiftAutoGUI.sendKeyShortcut(shortcut)
        case .scroll(let direction, let distance):
            switch direction {
            case .up:
                SwiftAutoGUI.vscroll(clicks: distance)
            case .down:
                SwiftAutoGUI.hscroll(clicks: -distance)
            case .left:
                SwiftAutoGUI.hscroll(clicks: distance)
            case .right:
                SwiftAutoGUI.hscroll(clicks: -distance)
            }
        }

    }
}
