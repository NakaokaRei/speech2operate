//
//  AppDelegate.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/18.
//

import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover?
    var statusBarItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.windows.forEach { $0.close() }
        NSApp.setActivationPolicy(.accessory)

        // ステータスバーにアイコンを追加
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: nil)
            button.action = #selector(togglePopover)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    @objc func togglePopover(_ sender: NSStatusBarButton) {
        if popover == nil {
            let popover = NSPopover()
            popover.behavior = .transient
            popover.animates = false
            popover.contentViewController = NSHostingController(rootView: ContentView())
            self.popover = popover
        }
        popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxY)
        popover?.contentViewController?.view.window?.makeKey()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
